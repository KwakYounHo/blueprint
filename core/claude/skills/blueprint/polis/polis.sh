#!/bin/bash
# Polis - Worker Registry Viewer
# View available Workers and their descriptions
#
# Usage:
#   polis --list                     List all workers with descriptions
#   polis <worker>                   Show worker instruction

set -e

# Source common functions
source "$(dirname "$0")/../_common.sh"

AGENTS_DIR="$PROJECT_ROOT/.claude/agents"

# Check if agents directory exists
if [ ! -d "$AGENTS_DIR" ]; then
  error "Agents directory not found: $AGENTS_DIR"
  exit 1
fi

# --list: Show all workers with descriptions
if [ "$1" = "--list" ] || [ "$1" = "-l" ]; then
  found=0
  echo "Available Workers:"
  echo ""
  for file in "$AGENTS_DIR"/*.md; do
    if [ -f "$file" ]; then
      name=$(basename "$file" .md)
      if [ "$name" != "README" ]; then
        desc=$(get_description "$file")
        printf "  %-15s %s\n" "$name" "$desc"
        found=1
      fi
    fi
  done

  if [ "$found" -eq 0 ]; then
    echo "  (no workers found)"
  fi
  exit 0
fi

# No argument: show usage
if [ -z "$1" ]; then
  echo "Polis - Worker Registry Viewer"
  echo ""
  echo "Usage:"
  echo "  polis --list               List all workers with descriptions"
  echo "  polis <worker>             Show worker instruction"
  echo ""
  echo "Examples:"
  echo "  blueprint.sh polis --list"
  echo "  blueprint.sh polis orchestrator"
  echo "  blueprint.sh polis specifier"
  exit 1
fi

WORKER="$1"
WORKER_FILE="$AGENTS_DIR/$WORKER.md"

# Check if worker exists
if [ ! -f "$WORKER_FILE" ]; then
  error "Worker not found: $WORKER"
  echo ""
  echo "Available workers:"
  for file in "$AGENTS_DIR"/*.md; do
    if [ -f "$file" ]; then
      name=$(basename "$file" .md)
      if [ "$name" != "README" ]; then
        echo "  - $name"
      fi
    fi
  done
  exit 1
fi

# Show worker instruction
cat "$WORKER_FILE"
