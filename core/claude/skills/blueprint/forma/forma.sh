#!/bin/bash
# Forma - Template Viewer
#
# Usage:
#   forma list                    List available templates
#   forma show <name>             Show template content
#
# Templates are stored in blueprint/templates/*.template.md

set -e

# Source common functions
source "$(dirname "$0")/../_common.sh"

COMMAND="$1"
TEMPLATE_DIR="$PROJECT_ROOT/blueprint/templates"

# === LIST ===
do_list() {
  if [ ! -d "$TEMPLATE_DIR" ]; then
    error "Template directory not found: $TEMPLATE_DIR"
    exit 1
  fi

  local found=0
  echo "Available templates:"
  echo ""

  for file in "$TEMPLATE_DIR"/*.template.md; do
    if [ -f "$file" ]; then
      name=$(basename "$file" .template.md)
      echo "  - $name"
      found=1
    fi
  done

  if [ "$found" -eq 0 ]; then
    echo "  (no templates found)"
  fi
}

# === SHOW ===
do_show() {
  local name="$1"

  if [ -z "$name" ]; then
    echo "Usage: forma show <name>"
    echo ""
    echo "Examples:"
    echo "  blueprint.sh forma show spec-lib"
    echo "  blueprint.sh forma show memory"
    echo "  blueprint.sh forma show discussion"
    echo ""
    echo "Run 'blueprint.sh forma list' to see available templates."
    exit 1
  fi

  local template_file="$TEMPLATE_DIR/${name}.template.md"

  if [ ! -f "$template_file" ]; then
    error "Template not found: $name"
    echo ""
    echo "Available templates:"
    for file in "$TEMPLATE_DIR"/*.template.md; do
      if [ -f "$file" ]; then
        n=$(basename "$file" .template.md)
        echo "  - $n"
      fi
    done
    exit 1
  fi

  cat "$template_file"
}

# === MAIN ===
case "$COMMAND" in
  list)
    do_list
    ;;
  show)
    shift
    do_show "$@"
    ;;
  *)
    echo "Forma - Template Viewer"
    echo ""
    echo "Usage:"
    echo "  forma list              List available templates"
    echo "  forma show <name>       Show template content"
    echo ""
    echo "Examples:"
    echo "  blueprint.sh forma list"
    echo "  blueprint.sh forma show spec-lib"
    echo "  blueprint.sh forma show memory"
    exit 1
    ;;
esac
