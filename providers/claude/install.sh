#!/usr/bin/env bash
#
# Blueprint Claude Code Provider
# Transforms and installs Blueprint instructions for Claude Code.
#
# Prerequisites:
#   ./install.sh must be run first (installs content to ~/.blueprint/)
#
# Usage:
#   ./providers/claude/install.sh [--dry-run]
#
# Reads from:
#   - instructions/agents/    → ~/.claude/agents/
#   - instructions/skills/    → ~/.claude/skills/{name}/SKILL.md
#

set -euo pipefail

# --- Config ---

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

INSTRUCTIONS_DIR="$REPO_ROOT/instructions"
HOOKS_DIR="$SCRIPT_DIR/hooks"

CLAUDE_DIR="${HOME}/.claude"
BLUEPRINT_HOME="${BLUEPRINT_HOME:-${HOME}/.blueprint}"

DRY_RUN=false

# --- Prerequisite Check ---

check_blueprint_installed() {
  if [ ! -d "$BLUEPRINT_HOME/base" ]; then
    echo "Blueprint content not found at $BLUEPRINT_HOME/base"
    echo ""
    echo "Run ./install.sh first to install Blueprint core content."
    exit 1
  fi
}

# --- Claude Code Bootstrap Template ---

BOOTSTRAP='## Platform: Claude Code

### Blueprint Access
Execute: `blueprint <submodule> [args]`

### Primitive Mapping
| Vocabulary | Implementation |
|------------|---------------|
| **delegate to [agent]** | Task tool with `subagent_type: {agent}`. Background: `run_in_background: true`. Permission: `mode: bypassPermissions` for read-only. |
| **ask user** | AskUserQuestion tool |
| **enter plan mode** | EnterPlanMode tool |
| **do not poll** | Do NOT use TaskOutput to check delegated results |

---'

# --- Capability Mapping ---

map_capabilities_to_tools() {
  local spec_file="$1"
  local tools=""

  if [ ! -f "$spec_file" ]; then
    echo "Read, Grep, Glob, Bash"
    return
  fi

  local caps
  caps=$(awk '/## Required Capabilities/,/^## /' "$spec_file" | grep '|' | grep -v 'Capability\|---' | cut -d'|' -f2 | sed 's/^ *//;s/ *$//')

  for cap in $caps; do
    case "$cap" in
      *"File reading"*) tools="${tools:+$tools, }Read" ;;
      *"Content search"*) tools="${tools:+$tools, }Grep" ;;
      *"File search"*) tools="${tools:+$tools, }Glob" ;;
      *"Shell execution"*) tools="${tools:+$tools, }Bash" ;;
    esac
  done

  echo "${tools:-Read, Grep, Glob, Bash}"
}

# --- Extract description from spec ---

get_description() {
  local spec_file="$1"
  if [ ! -f "$spec_file" ]; then
    echo ""
    return
  fi
  awk '/^## Description/{found=1; next} found && /^[^ ]/{print; exit}' "$spec_file" | sed 's/^ *//'
}

# --- Logging ---

log_info()  { echo -e "\033[0;34m[INFO]\033[0m $1"; }
log_ok()    { echo -e "\033[0;32m[OK]\033[0m $1"; }
log_dry()   { echo -e "\033[0;33m[DRY-RUN]\033[0m $1"; }
log_warn()  { echo -e "\033[0;33m[WARN]\033[0m $1"; }

# --- Install Functions ---

install_agents() {
  local agents_dir="$INSTRUCTIONS_DIR/agents"
  local target_dir="$CLAUDE_DIR/agents"

  [ ! -d "$agents_dir" ] && return

  log_info "Installing agents → $target_dir"

  [ "$DRY_RUN" = false ] && mkdir -p "$target_dir"

  for file in "$agents_dir"/*.md; do
    [ ! -f "$file" ] && continue
    [[ "$file" == *.spec.md ]] && continue

    local name
    name=$(basename "$file" .md)
    local spec="$agents_dir/${name}.spec.md"
    local desc
    desc=$(get_description "$spec")
    local tools
    tools=$(map_capabilities_to_tools "$spec")

    local output
    output=$(printf '%s\n\n%s\n\n%s' \
      "---
name: ${name}
description: ${desc}
tools: ${tools}
---" \
      "$BOOTSTRAP" \
      "$(cat "$file")")

    if [ "$DRY_RUN" = true ]; then
      log_dry "  $name"
    else
      echo "$output" > "$target_dir/${name}.md"
      log_ok "  $name"
    fi
  done
}

install_skills() {
  local skills_dir="$INSTRUCTIONS_DIR/skills"
  local target_dir="$CLAUDE_DIR/skills"

  [ ! -d "$skills_dir" ] && return

  log_info "Installing skills → $target_dir"

  for file in "$skills_dir"/*.md; do
    [ ! -f "$file" ] && continue
    [[ "$file" == *.spec.md ]] && continue

    local name
    name=$(basename "$file" .md)
    local spec="$skills_dir/${name}.spec.md"
    local desc
    desc=$(get_description "$spec")

    local skill_dir="$target_dir/$name"

    local output
    output=$(printf '%s\n\n%s\n\n%s' \
      "---
name: ${name}
description: ${desc}
---" \
      "$BOOTSTRAP" \
      "$(cat "$file")")

    if [ "$DRY_RUN" = true ]; then
      log_dry "  $name"
    else
      mkdir -p "$skill_dir"
      echo "$output" > "$skill_dir/SKILL.md"
      log_ok "  $name"
    fi
  done
}

install_hooks() {
  [ ! -d "$HOOKS_DIR" ] && return

  local target_dir="$CLAUDE_DIR/hooks"

  log_info "Installing hooks → $target_dir"

  if [ "$DRY_RUN" = true ]; then
    log_dry "  hooks/"
  else
    mkdir -p "$target_dir"
    rsync -a "$HOOKS_DIR/" "$target_dir/"
    log_ok "  hooks/"
  fi
}

configure_session_hook() {
  local settings_file="$CLAUDE_DIR/settings.json"
  local hook_path="~/.claude/hooks/session-init.sh"

  log_info "Configuring SessionStart hook"

  if ! command -v jq &>/dev/null; then
    log_warn "jq not found. Please manually add SessionStart hook to $settings_file:"
    echo ""
    echo '  "hooks": {'
    echo '    "SessionStart": ['
    echo "      {\"hooks\": [{\"type\": \"command\", \"command\": \"$hook_path\"}]}"
    echo '    ]'
    echo '  }'
    echo ""
    return 0
  fi

  if [ "$DRY_RUN" = true ]; then
    log_dry "  SessionStart hook in settings.json"
    return 0
  fi

  [ ! -f "$settings_file" ] && echo '{}' > "$settings_file"

  if jq -e '.hooks.SessionStart[]?.hooks[]? | select(.command | contains("session-init.sh"))' "$settings_file" >/dev/null 2>&1; then
    log_ok "  SessionStart hook already configured (skipped)"
    return 0
  fi

  local tmp_file
  tmp_file=$(mktemp)
  jq --arg cmd "$hook_path" '
    .hooks //= {} |
    .hooks.SessionStart //= [] |
    .hooks.SessionStart += [{"hooks": [{"type": "command", "command": $cmd}]}]
  ' "$settings_file" > "$tmp_file" && mv "$tmp_file" "$settings_file"

  log_ok "  SessionStart hook configured"
}

# --- Main ---

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run) DRY_RUN=true; shift ;;
      -h|--help)
        echo "Usage: $(basename "$0") [--dry-run]"
        echo "Installs Blueprint instructions for Claude Code."
        echo ""
        echo "Prerequisite: ./install.sh (installs Blueprint content first)"
        exit 0 ;;
      *) echo "Unknown option: $1"; exit 1 ;;
    esac
  done

  echo ""
  log_info "Blueprint Claude Code Provider"
  log_info "==============================="
  [ "$DRY_RUN" = true ] && log_warn "DRY-RUN MODE"
  echo ""

  check_blueprint_installed

  install_agents
  echo ""
  install_skills
  echo ""
  install_hooks
  echo ""
  configure_session_hook

  echo ""
  if [ "$DRY_RUN" = true ]; then
    log_warn "Dry run complete. No files were changed."
  else
    log_ok "Claude Code provider installed!"
    echo ""
    log_info "Next steps:"
    log_info "  1. cd /path/to/your/project"
    log_info "  2. blueprint project init <alias>"
  fi
}

main "$@"
