#!/bin/bash
# Blueprint - Unified Framework CLI
#
# Usage: blueprint.sh <submodule> [args...]
#
# Submodules:
#   aegis     Gate validation and aspects
#   forma     Document templates
#   frontis   FrontMatter search and schemas
#   hermes    Worker handoff forms
#   lexis     Constitution viewer
#   polis     Worker registry

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SUBMODULE="$1"

# Show help
show_help() {
  cat << 'EOF'
Blueprint - Unified Framework CLI

Usage: blueprint.sh <submodule> [args...]

Submodules:
  aegis     Gate validation and aspects
  forma     Document templates
  frontis   FrontMatter search and schemas
  hermes    Worker handoff forms
  lexis     Constitution viewer
  polis     Worker registry

Options:
  --help, -h    Show this help
  --list, -l    List available submodules

Examples:
  blueprint.sh aegis --list
  blueprint.sh frontis search type spec
  blueprint.sh forma show spec-lib
  blueprint.sh hermes orchestrator specifier
  blueprint.sh lexis specifier
  blueprint.sh polis --list

Run 'blueprint.sh <submodule>' without args for submodule-specific help.
EOF
}

# List submodules
list_submodules() {
  echo "Available submodules:"
  echo ""
  printf "  %-12s %s\n" "aegis" "Gate validation and aspects"
  printf "  %-12s %s\n" "forma" "Document templates"
  printf "  %-12s %s\n" "frontis" "FrontMatter search and schemas"
  printf "  %-12s %s\n" "hermes" "Worker handoff forms"
  printf "  %-12s %s\n" "lexis" "Constitution viewer"
  printf "  %-12s %s\n" "polis" "Worker registry"
}

# Main dispatch
case "$SUBMODULE" in
  aegis|forma|frontis|hermes|lexis|polis)
    shift
    exec "$SCRIPT_DIR/$SUBMODULE/$SUBMODULE.sh" "$@"
    ;;
  --help|-h)
    show_help
    ;;
  --list|-l)
    list_submodules
    ;;
  "")
    show_help
    ;;
  *)
    echo "[ERROR] Unknown submodule: $SUBMODULE" >&2
    echo ""
    list_submodules
    exit 1
    ;;
esac
