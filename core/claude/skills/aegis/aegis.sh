#!/bin/bash
# Aegis - Gate Viewer
# View gate definitions and their aspects
#
# Usage:
#   aegis --list                    List all gates
#   aegis <gate>                    Show gate definition
#   aegis <gate> --aspects          List aspects for gate
#   aegis <gate> <aspect>           Show specific aspect

set -e

# Project root detection with fallback
PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../../.." && pwd)}"

GATES_DIR="$PROJECT_ROOT/blueprint/gates"

# Extract FrontMatter from file (between first and second ---)
get_frontmatter() {
  local file="$1"
  awk '/^---$/{if(++c==2)exit}c' "$file" 2>/dev/null
}

# Extract field value from FrontMatter
get_field() {
  local frontmatter="$1"
  local field="$2"
  echo "$frontmatter" | grep "^${field}:" | sed "s/^${field}:[[:space:]]*//" | sed 's/^"//' | sed 's/"$//'
}

# Extract description from FrontMatter (proper YAML parsing)
get_description() {
  local file="$1"
  local frontmatter
  frontmatter=$(get_frontmatter "$file")
  local desc
  desc=$(get_field "$frontmatter" "description")
  if [ -z "$desc" ]; then
    echo "(no description)"
  else
    echo "$desc"
  fi
}

# Helper: list all gates with descriptions
list_gates() {
  if [ ! -d "$GATES_DIR" ]; then
    echo "[ERROR] Gates directory not found: $GATES_DIR"
    return 1
  fi

  local found=0
  echo "Available gates:"
  echo ""
  for dir in "$GATES_DIR"/*/; do
    if [ -d "$dir" ]; then
      name=$(basename "$dir")
      if [ "$name" != "README.md" ]; then
        local gate_file="$dir/gate.md"
        if [ -f "$gate_file" ]; then
          desc=$(get_description "$gate_file")
          printf "  %-20s %s\n" "$name" "$desc"
        else
          printf "  %-20s %s\n" "$name" "(no gate.md)"
        fi
        found=1
      fi
    fi
  done

  if [ "$found" -eq 0 ]; then
    echo "  (no gates found)"
  fi
}

# Helper: list aspects for a gate with descriptions
list_aspects() {
  local gate="$1"
  local aspects_dir="$GATES_DIR/$gate/aspects"

  if [ ! -d "$aspects_dir" ]; then
    echo "[INFO] No aspects directory for gate: $gate"
    return
  fi

  local found=0
  echo "Aspects for '$gate' gate:"
  echo ""
  for file in "$aspects_dir"/*.md; do
    if [ -f "$file" ]; then
      name=$(basename "$file" .md)
      desc=$(get_description "$file")
      printf "  %-25s %s\n" "$name" "$desc"
      found=1
    fi
  done

  if [ "$found" -eq 0 ]; then
    echo "  (no aspects found)"
  fi
}

# --list: Show all gates
if [ "$1" = "--list" ] || [ "$1" = "-l" ]; then
  list_gates
  exit 0
fi

# No argument: show usage
if [ -z "$1" ]; then
  echo "Aegis - Gate Viewer"
  echo ""
  echo "Usage:"
  echo "  aegis --list                 List all gates"
  echo "  aegis <gate>                 Show gate definition"
  echo "  aegis <gate> --aspects       List aspects for gate"
  echo "  aegis <gate> <aspect>        Show specific aspect"
  echo ""
  echo "Examples:"
  echo "  aegis --list"
  echo "  aegis documentation"
  echo "  aegis documentation --aspects"
  echo "  aegis documentation schema-validation"
  exit 1
fi

GATE="$1"
GATE_DIR="$GATES_DIR/$GATE"

# Check if gate exists
if [ ! -d "$GATE_DIR" ]; then
  echo "[ERROR] Gate not found: $GATE"
  echo ""
  list_gates
  exit 1
fi

# aegis <gate> --aspects
if [ "$2" = "--aspects" ] || [ "$2" = "-a" ]; then
  list_aspects "$GATE"
  exit 0
fi

# aegis <gate> <aspect>
if [ -n "$2" ]; then
  ASPECT="$2"
  ASPECT_FILE="$GATE_DIR/aspects/$ASPECT.md"

  if [ ! -f "$ASPECT_FILE" ]; then
    echo "[ERROR] Aspect not found: $ASPECT"
    echo ""
    list_aspects "$GATE"
    exit 1
  fi

  cat "$ASPECT_FILE"
  exit 0
fi

# aegis <gate> - show gate definition
GATE_FILE="$GATE_DIR/gate.md"

if [ ! -f "$GATE_FILE" ]; then
  echo "[ERROR] Gate definition not found: $GATE_FILE"
  exit 1
fi

cat "$GATE_FILE"
