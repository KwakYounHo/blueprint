#!/bin/bash
# Frontis - FrontMatter Search & Schema Viewer
#
# Usage:
#   frontis search <field> <value> [path]    Search documents by FrontMatter
#   frontis show <file> [file...]            Show frontmatter of file(s)
#   frontis schema <type>                    View schema definition
#   frontis schema --list                    List available schemas

set -e

COMMAND="$1"
SCHEMA_DIR="blueprint/front-matters"

# === SEARCH ===
do_search() {
  local field="$1"
  local value="$2"
  local search_path="${3:-.}"

  if [ -z "$field" ] || [ -z "$value" ]; then
    echo "Usage: frontis search <field> <value> [path]"
    echo ""
    echo "Examples:"
    echo "  frontis search type task"
    echo "  frontis search status active blueprint/"
    exit 1
  fi

  # Check if search path exists
  if [ ! -d "$search_path" ]; then
    echo "[ERROR] Search path not found: $search_path"
    exit 1
  fi

  local found=0
  while IFS= read -r file; do
    frontmatter=$(awk '/^---$/{if(++c==2)exit}c' "$file" 2>/dev/null)
    if echo "$frontmatter" | grep -q "^${field}: *${value}"; then
      echo "$file"
      found=1
    fi
  done < <(find "$search_path" -name "*.md" -type f 2>/dev/null)

  if [ "$found" -eq 0 ]; then
    echo "[INFO] No documents found with ${field}: ${value} in ${search_path}"
  fi
}

# === SHOW ===
do_show() {
  if [ $# -eq 0 ]; then
    echo "Usage: frontis show <file> [file...]"
    echo ""
    echo "Examples:"
    echo "  frontis show blueprint/tasks/task-001.md"
    echo "  frontis show file1.md file2.md file3.md"
    exit 1
  fi

  for file in "$@"; do
    if [ ! -f "$file" ]; then
      echo "=== $file ==="
      echo "File not found"
      echo ""
      continue
    fi

    echo "=== $file ==="
    awk '/^---$/{if(++c==2){print "---"; exit}}{if(c)print}' "$file" 2>/dev/null
    echo ""
  done
}

# === SCHEMA ===
do_schema() {
  local type="$1"

  # --list: Show available schemas
  if [ "$type" = "--list" ] || [ "$type" = "-l" ]; then
    if [ ! -d "$SCHEMA_DIR" ]; then
      echo "[ERROR] Schema directory not found: $SCHEMA_DIR"
      exit 1
    fi

    local found=0
    echo "Available schemas:"
    echo ""
    for file in "$SCHEMA_DIR"/*.schema.md; do
      if [ -f "$file" ]; then
        name=$(basename "$file" .schema.md)
        echo "  - $name"
        found=1
      fi
    done

    if [ "$found" -eq 0 ]; then
      echo "  (no schemas found)"
    fi
    exit 0
  fi

  # No type: show usage
  if [ -z "$type" ]; then
    echo "Usage: frontis schema <type>"
    echo "       frontis schema --list"
    echo ""
    echo "Examples:"
    echo "  frontis schema task"
    echo "  frontis schema aspect"
    exit 1
  fi

  # Show specific schema
  local schema_file="$SCHEMA_DIR/${type}.schema.md"

  if [ ! -f "$schema_file" ]; then
    echo "Schema not found: $type"
    echo ""
    echo "Available schemas:"
    for file in "$SCHEMA_DIR"/*.schema.md; do
      if [ -f "$file" ]; then
        name=$(basename "$file" .schema.md)
        echo "  - $name"
      fi
    done
    exit 1
  fi

  cat "$schema_file"
}

# === MAIN ===
case "$COMMAND" in
  search)
    shift
    do_search "$@"
    ;;
  show)
    shift
    do_show "$@"
    ;;
  schema)
    shift
    do_schema "$@"
    ;;
  *)
    echo "Frontis - FrontMatter Search & Schema Viewer"
    echo ""
    echo "Usage:"
    echo "  frontis search <field> <value> [path]    Search by FrontMatter"
    echo "  frontis show <file> [file...]            Show frontmatter"
    echo "  frontis schema <type>                    View schema"
    echo "  frontis schema --list                    List schemas"
    echo ""
    echo "Examples:"
    echo "  frontis search type task"
    echo "  frontis show blueprint/tasks/task-001.md"
    echo "  frontis schema aspect"
    exit 1
    ;;
esac
