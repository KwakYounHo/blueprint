#!/usr/bin/env bash
#
# Blueprint Content Installer
# Installs Blueprint core content to ~/.blueprint/
#
# Usage:
#   ./install.sh [--dry-run]
#
# This sets up the minimal environment for Blueprint to exist.
# After this, install the CLI binary and optionally a platform provider.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_DIR="$SCRIPT_DIR/core"
INSTRUCTIONS_DIR="$SCRIPT_DIR/instructions"
BLUEPRINT_HOME="${BLUEPRINT_HOME:-$HOME/.blueprint}"
BLUEPRINT_BASE="$BLUEPRINT_HOME/base"

DRY_RUN=false

log_info()  { echo -e "\033[0;34m[INFO]\033[0m $1"; }
log_ok()    { echo -e "\033[0;32m[OK]\033[0m $1"; }
log_dry()   { echo -e "\033[0;33m[DRY-RUN]\033[0m $1"; }
log_warn()  { echo -e "\033[0;33m[WARN]\033[0m $1"; }

copy_directory() {
  local src="$1" dest="$2" name="$3"
  [ ! -d "$src" ] && return

  if [ "$DRY_RUN" = true ]; then
    log_dry "Would copy: $name/ → $dest/"
  else
    mkdir -p "$dest"
    rsync -a "$src/" "$dest/"
    log_ok "$name/"
  fi
}

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run) DRY_RUN=true; shift ;;
      -h|--help)
        echo "Usage: $(basename "$0") [--dry-run]"
        echo "Installs Blueprint core content to ~/.blueprint/"
        exit 0 ;;
      *) echo "Unknown option: $1"; exit 1 ;;
    esac
  done

  echo ""
  log_info "Blueprint Content Installer"
  log_info "============================"
  log_info "Target: $BLUEPRINT_HOME"
  [ "$DRY_RUN" = true ] && log_warn "DRY-RUN MODE"
  echo ""

  # Core system content (Layer 0)
  log_info "Installing core content → $BLUEPRINT_BASE"
  copy_directory "$CORE_DIR/constitutions" "$BLUEPRINT_BASE/constitutions" "constitutions"
  copy_directory "$CORE_DIR/forms" "$BLUEPRINT_BASE/forms" "forms"
  copy_directory "$CORE_DIR/front-matters" "$BLUEPRINT_BASE/front-matters" "front-matters"
  copy_directory "$CORE_DIR/gates" "$BLUEPRINT_BASE/gates" "gates"
  copy_directory "$CORE_DIR/templates" "$BLUEPRINT_BASE/templates" "templates"

  echo ""

  # Instructions (Layer 2-3) — for CLI access (polis, etc.)
  log_info "Installing instructions → $BLUEPRINT_BASE/instructions"
  copy_directory "$INSTRUCTIONS_DIR/agents" "$BLUEPRINT_BASE/instructions/agents" "instructions/agents"
  copy_directory "$INSTRUCTIONS_DIR/skills" "$BLUEPRINT_BASE/instructions/skills" "instructions/skills"

  echo ""

  # Projects directory
  local projects_dir="$BLUEPRINT_HOME/projects"
  if [ "$DRY_RUN" = true ]; then
    log_dry "Would create: projects/"
  else
    mkdir -p "$projects_dir"
    log_ok "projects/"
  fi

  echo ""
  if [ "$DRY_RUN" = true ]; then
    log_warn "Dry run complete. No files were changed."
  else
    log_ok "Blueprint content installed!"
    echo ""
    log_info "Next steps:"
    log_info "  1. Install CLI: cargo install --path cli/"
    log_info "  2. Install for your Code Assistant: ./providers/claude/install.sh"
  fi
}

main "$@"
