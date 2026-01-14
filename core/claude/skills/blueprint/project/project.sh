#!/bin/bash
# Blueprint Project Submodule
# Manage project aliases for cross-machine portability
#
# Usage: blueprint project <command> [args]

set -e

source "$(dirname "$0")/../_common.sh"

COMMAND="$1"

# =============================================================================
# Help
# =============================================================================

show_help() {
  cat << 'EOF'
Project - Manage project aliases for cross-machine portability

Usage:
  blueprint project init <alias> [--notes "text"]   Initialize new project
  blueprint project list                            List all projects
  blueprint project show <alias>                    Show project details
  blueprint project remove <alias>                  Remove project
  blueprint project link <alias>                    Link current path to project
  blueprint project unlink <alias> [path]           Unlink path from project

Options:
  -h, --help    Show this help message

Examples:
  blueprint project init myproject
  blueprint project init myproject --notes "My awesome project"
  blueprint project list
  blueprint project show myproject
  blueprint project link myproject
  blueprint project unlink myproject /old/path
EOF
}

# =============================================================================
# Utility Functions
# =============================================================================

require_jq() {
  if ! command -v jq &> /dev/null; then
    error "jq is required for project management."
    echo "Install jq: https://stedolan.github.io/jq/download/"
    exit 1
  fi
}

# =============================================================================
# Commands
# =============================================================================

do_init() {
  local alias_name="$1"
  shift || true
  local notes=""

  # Parse --notes flag
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --notes)
        notes="$2"
        shift 2
        ;;
      *)
        error "Unknown option: $1"
        exit 1
        ;;
    esac
  done

  if [ -z "$alias_name" ]; then
    echo "Usage: blueprint project init <alias> [--notes \"text\"]"
    exit 1
  fi

  require_jq

  local current_path
  current_path="${CLAUDE_PROJECT_DIR:-$(pwd)}"

  # Validate alias format
  if ! [[ "$alias_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    error "Invalid alias. Use alphanumeric characters, dashes, and underscores only."
    exit 1
  fi

  # Initialize registry if needed
  init_registry

  # Check if path already registered
  local existing_alias
  existing_alias=$(resolve_project_alias "$current_path")
  if [ -n "$existing_alias" ]; then
    error "Path already registered as '$existing_alias'."
    echo "Use 'blueprint project show $existing_alias' to view details."
    exit 1
  fi

  # Check if alias exists
  if jq -e --arg a "$alias_name" '.projects[] | select(.alias == $a)' "$BLUEPRINT_REGISTRY" >/dev/null 2>&1; then
    error "Alias '$alias_name' already exists."
    echo "Use 'blueprint project link $alias_name' to add current path."
    exit 1
  fi

  local data_dir="$HOME/.claude/blueprint/$alias_name"

  # Check for legacy directory
  local legacy_dirname
  legacy_dirname=$(path_to_dirname "$current_path")
  local legacy_dir="$HOME/.claude/blueprint/$legacy_dirname"

  if [ -d "$legacy_dir" ] && [ ! -d "$data_dir" ]; then
    info "Found existing data at $legacy_dir"
    info "Renaming to $data_dir"
    mv "$legacy_dir" "$data_dir"
  elif [ ! -d "$data_dir" ]; then
    # Create new data directory
    mkdir -p "$data_dir"

    # Try to copy framework files from various sources
    local source_dir=""

    # Check environment variable first
    if [ -n "${BLUEPRINT_FRAMEWORK_DIR:-}" ] && [ -d "$BLUEPRINT_FRAMEWORK_DIR/core" ]; then
      source_dir="$BLUEPRINT_FRAMEWORK_DIR/core"
    # Check project root (for development)
    elif [ -d "$PROJECT_ROOT/core" ]; then
      source_dir="$PROJECT_ROOT/core"
    fi

    if [ -n "$source_dir" ]; then
      [ -d "$source_dir/constitutions" ] && rsync -a "$source_dir/constitutions/" "$data_dir/constitutions/"
      [ -d "$source_dir/forms" ] && rsync -a "$source_dir/forms/" "$data_dir/forms/"
      [ -d "$source_dir/front-matters" ] && rsync -a "$source_dir/front-matters/" "$data_dir/front-matters/"
      [ -d "$source_dir/gates" ] && rsync -a "$source_dir/gates/" "$data_dir/gates/"
      [ -d "$source_dir/templates" ] && rsync -a "$source_dir/templates/" "$data_dir/templates/"
    fi

    mkdir -p "$data_dir/plans"
  fi

  # Add to registry
  local tmp_file
  tmp_file=$(mktemp)
  jq --arg alias "$alias_name" \
     --arg path "$current_path" \
     --arg notes "$notes" \
     '.projects += [{"alias": $alias, "paths": [$path], "notes": $notes}]' \
     "$BLUEPRINT_REGISTRY" > "$tmp_file" && mv "$tmp_file" "$BLUEPRINT_REGISTRY"

  echo ""
  info "Project initialized: $alias_name"
  echo "  Path: $current_path"
  echo "  Data: $data_dir"
  [ -n "$notes" ] && echo "  Notes: $notes"
}

do_list() {
  require_jq
  init_registry

  local count
  count=$(jq '.projects | length' "$BLUEPRINT_REGISTRY")

  if [ "$count" -eq 0 ]; then
    echo "No projects registered."
    echo ""
    echo "Run 'blueprint project init <alias>' to register a project."
    exit 0
  fi

  echo "Projects ($count):"
  echo ""

  jq -r '.projects[] | "\(.alias)\t\(.paths | length)\t\(.notes // "-")"' "$BLUEPRINT_REGISTRY" | \
    while IFS=$'\t' read -r alias_name paths notes; do
      printf "  %-16s (%d paths)  %s\n" "$alias_name" "$paths" "$notes"
    done
}

do_show() {
  local alias_name="$1"

  if [ -z "$alias_name" ]; then
    echo "Usage: blueprint project show <alias>"
    exit 1
  fi

  require_jq
  init_registry

  local project
  project=$(jq -e --arg a "$alias_name" '.projects[] | select(.alias == $a)' "$BLUEPRINT_REGISTRY" 2>/dev/null)

  if [ -z "$project" ]; then
    error "Project '$alias_name' not found."
    echo ""
    echo "Available projects:"
    do_list
    exit 1
  fi

  echo "Project: $alias_name"
  echo "Notes: $(echo "$project" | jq -r '.notes // "-"')"
  echo "Paths:"
  echo "$project" | jq -r '.paths[]' | while read -r path; do
    echo "  - $path"
  done
  echo "Data: ~/.claude/blueprint/$alias_name/"
}

do_remove() {
  local alias_name="$1"

  if [ -z "$alias_name" ]; then
    echo "Usage: blueprint project remove <alias>"
    exit 1
  fi

  require_jq
  init_registry

  # Check exists
  if ! jq -e --arg a "$alias_name" '.projects[] | select(.alias == $a)' "$BLUEPRINT_REGISTRY" >/dev/null 2>&1; then
    error "Project '$alias_name' not found."
    exit 1
  fi

  # Confirm
  read -p "Remove project '$alias_name'? [y/N] " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
  fi

  # Ask about data directory
  local data_dir="$HOME/.claude/blueprint/$alias_name"
  if [ -d "$data_dir" ]; then
    read -p "Also delete data directory ($data_dir)? [y/N] " delete_data
    if [[ "$delete_data" =~ ^[Yy]$ ]]; then
      rm -rf "$data_dir"
      info "Data directory deleted."
    fi
  fi

  # Remove from registry
  local tmp_file
  tmp_file=$(mktemp)
  jq --arg a "$alias_name" 'del(.projects[] | select(.alias == $a))' "$BLUEPRINT_REGISTRY" > "$tmp_file" && mv "$tmp_file" "$BLUEPRINT_REGISTRY"

  info "Project '$alias_name' removed."
}

do_link() {
  local alias_name="$1"
  local current_path
  current_path="${CLAUDE_PROJECT_DIR:-$(pwd)}"

  if [ -z "$alias_name" ]; then
    echo "Usage: blueprint project link <alias>"
    exit 1
  fi

  require_jq
  init_registry

  # Check alias exists
  if ! jq -e --arg a "$alias_name" '.projects[] | select(.alias == $a)' "$BLUEPRINT_REGISTRY" >/dev/null 2>&1; then
    error "Project '$alias_name' not found."
    echo ""
    echo "Available projects:"
    do_list
    exit 1
  fi

  # Check path not already linked
  local existing
  existing=$(jq -r --arg a "$alias_name" --arg p "$current_path" \
    '.projects[] | select(.alias == $a) | .paths[] | select(. == $p)' "$BLUEPRINT_REGISTRY")

  if [ -n "$existing" ]; then
    error "Path already linked to '$alias_name'."
    exit 1
  fi

  # Add path
  local tmp_file
  tmp_file=$(mktemp)
  jq --arg a "$alias_name" --arg p "$current_path" \
    '(.projects[] | select(.alias == $a) | .paths) += [$p]' \
    "$BLUEPRINT_REGISTRY" > "$tmp_file" && mv "$tmp_file" "$BLUEPRINT_REGISTRY"

  info "Path linked to '$alias_name'."
  echo "  $current_path"
}

do_unlink() {
  local alias_name="$1"
  local path="${2:-${CLAUDE_PROJECT_DIR:-$(pwd)}}"

  if [ -z "$alias_name" ]; then
    echo "Usage: blueprint project unlink <alias> [path]"
    exit 1
  fi

  require_jq
  init_registry

  # Check alias exists
  local project
  project=$(jq -e --arg a "$alias_name" '.projects[] | select(.alias == $a)' "$BLUEPRINT_REGISTRY" 2>/dev/null)

  if [ -z "$project" ]; then
    error "Project '$alias_name' not found."
    exit 1
  fi

  # Check path count
  local path_count
  path_count=$(echo "$project" | jq '.paths | length')

  if [ "$path_count" -eq 1 ]; then
    echo "Warning: This is the last path for '$alias_name'."
    read -p "Remove project entirely? [y/N] " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      do_remove "$alias_name"
      return
    else
      echo "Cancelled."
      exit 0
    fi
  fi

  # Remove path
  local tmp_file
  tmp_file=$(mktemp)
  jq --arg a "$alias_name" --arg p "$path" \
    '(.projects[] | select(.alias == $a) | .paths) -= [$p]' \
    "$BLUEPRINT_REGISTRY" > "$tmp_file" && mv "$tmp_file" "$BLUEPRINT_REGISTRY"

  info "Path unlinked from '$alias_name'."
}

# =============================================================================
# Main Dispatch
# =============================================================================

case "$COMMAND" in
  init)
    shift
    do_init "$@"
    ;;
  list)
    do_list
    ;;
  show)
    shift
    do_show "$@"
    ;;
  remove)
    shift
    do_remove "$@"
    ;;
  link)
    shift
    do_link "$@"
    ;;
  unlink)
    shift
    do_unlink "$@"
    ;;
  -h|--help|"")
    show_help
    ;;
  *)
    error "Unknown command: $COMMAND"
    echo ""
    show_help
    exit 1
    ;;
esac
