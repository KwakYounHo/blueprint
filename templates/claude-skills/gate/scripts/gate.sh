#!/bin/bash
# Gate Viewer
# View gate definitions and their aspects
#
# Usage:
#   gate.sh --list                    List all gates
#   gate.sh <gate>                    Show gate definition
#   gate.sh <gate> --aspects          List aspects for gate
#   gate.sh <gate> <aspect>           Show specific aspect

set -e

GATES_DIR="blueprint/gates"

# Helper: list all gates
list_gates() {
  echo "Available gates:"
  echo ""
  for dir in "$GATES_DIR"/*/; do
    if [ -d "$dir" ]; then
      name=$(basename "$dir")
      if [ "$name" != "README.md" ]; then
        echo "  - $name"
      fi
    fi
  done
}

# Helper: list aspects for a gate
list_aspects() {
  local gate="$1"
  local aspects_dir="$GATES_DIR/$gate/aspects"

  if [ ! -d "$aspects_dir" ]; then
    echo "No aspects found for gate: $gate"
    return
  fi

  echo "Aspects for '$gate' gate:"
  echo ""
  for file in "$aspects_dir"/*.md; do
    if [ -f "$file" ]; then
      name=$(basename "$file" .md)
      echo "  - $name"
    fi
  done
}

# --list: Show all gates
if [ "$1" = "--list" ] || [ "$1" = "-l" ]; then
  list_gates
  exit 0
fi

# No argument: show usage
if [ -z "$1" ]; then
  echo "Usage:"
  echo "  gate.sh --list                 List all gates"
  echo "  gate.sh <gate>                 Show gate definition"
  echo "  gate.sh <gate> --aspects       List aspects for gate"
  echo "  gate.sh <gate> <aspect>        Show specific aspect"
  echo ""
  echo "Examples:"
  echo "  gate.sh --list"
  echo "  gate.sh specification"
  echo "  gate.sh specification --aspects"
  echo "  gate.sh specification workflow-structure"
  exit 1
fi

GATE="$1"
GATE_DIR="$GATES_DIR/$GATE"

# Check if gate exists
if [ ! -d "$GATE_DIR" ]; then
  echo "Gate not found: $GATE"
  echo ""
  list_gates
  exit 1
fi

# gate.sh <gate> --aspects
if [ "$2" = "--aspects" ] || [ "$2" = "-a" ]; then
  list_aspects "$GATE"
  exit 0
fi

# gate.sh <gate> <aspect>
if [ -n "$2" ]; then
  ASPECT="$2"
  ASPECT_FILE="$GATE_DIR/aspects/$ASPECT.md"

  if [ ! -f "$ASPECT_FILE" ]; then
    echo "Aspect not found: $ASPECT"
    echo ""
    list_aspects "$GATE"
    exit 1
  fi

  cat "$ASPECT_FILE"
  exit 0
fi

# gate.sh <gate> - show gate definition
GATE_FILE="$GATE_DIR/gate.md"

if [ ! -f "$GATE_FILE" ]; then
  echo "Gate definition not found: $GATE_FILE"
  exit 1
fi

cat "$GATE_FILE"
