#!/bin/bash
# Frontis - FrontMatter Search & Schema Viewer
#
# Usage:
#   frontis search <field> <value> [path]    Search documents by FrontMatter
#   frontis show <file> [file...]            Show frontmatter of file(s)
#   frontis schema <type>                    View schema definition
#   frontis schema --list                    List available schemas
#
# Supports both Markdown (.md) and YAML (.yaml) files

set -e

COMMAND="$1"
SCHEMA_DIR="blueprint/front-matters"

# === HELPER: Extract FrontMatter ===
extract_frontmatter() {
  local file="$1"

  if [[ "$file" == *.yaml ]]; then
    # YAML: entire file is structured data, treat top-level as frontmatter
    cat "$file" 2>/dev/null
  else
    # Markdown: extract --- block
    awk '/^---$/{if(++c==2)exit}c' "$file" 2>/dev/null
  fi
}

# === SEARCH ===
do_search() {
  local field="$1"
  local value="$2"
  local search_path="${3:-.}"

  if [ -z "$field" ] || [ -z "$value" ]; then
    echo "Usage: frontis search <field> <value> [path]"
    echo ""
    echo "Examples:"
    echo "  frontis search type spec"
    echo "  frontis search status ready blueprint/specs/"
    echo "  frontis search spec-type lib blueprint/specs/lib/"
    exit 1
  fi

  # Check if search path exists
  if [ ! -d "$search_path" ]; then
    echo "[ERROR] Search path not found: $search_path"
    exit 1
  fi

  local found=0
  # Search both .md and .yaml files
  while IFS= read -r file; do
    frontmatter=$(extract_frontmatter "$file")
    if echo "$frontmatter" | grep -q "^${field}: *${value}"; then
      echo "$file"
      found=1
    fi
  done < <(find "$search_path" \( -name "*.md" -o -name "*.yaml" \) -type f 2>/dev/null)

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
    echo "  frontis show blueprint/discussions/001.md"
    echo "  frontis show blueprint/specs/lib/prompt/spec.yaml"
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
    if [[ "$file" == *.yaml ]]; then
      # YAML: show entire file (it's all structured data)
      cat "$file" 2>/dev/null
    else
      # Markdown: show frontmatter block only
      awk '/^---$/{if(++c==2){print "---"; exit}}{if(c)print}' "$file" 2>/dev/null
    fi
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
    echo "  frontis schema spec"
    echo "  frontis schema tokens"
    echo "  frontis schema ast"
    exit 1
  fi

  # Show specific schema
  # "schema" type uses base.schema.md (avoids self-referential schema.schema.md)
  if [ "$type" = "schema" ]; then
    type="base"
  fi

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
    echo "Supported file types: .md, .yaml"
    echo ""
    echo "Examples:"
    echo "  frontis search type spec"
    echo "  frontis search status ready blueprint/specs/"
    echo "  frontis show blueprint/specs/lib/prompt/spec.yaml"
    echo "  frontis schema spec"
    exit 1
    ;;
esac
