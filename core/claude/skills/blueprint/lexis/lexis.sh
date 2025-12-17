#!/bin/bash
# Lexis - Constitution Viewer
# View worker-specific constitutions (base loaded via SessionStart hook)
#
# Usage:
#   lexis --list                     List all workers
#   lexis <worker>                   Show worker constitution
#   lexis --base                     Show base constitution only

set -e

# Source common functions
source "$(dirname "$0")/../_common.sh"

CONST_DIR="$PROJECT_ROOT/blueprint/constitutions"
BASE_FILE="$CONST_DIR/base.md"
WORKERS_DIR="$CONST_DIR/workers"

# Check if constitutions exist
if [ ! -f "$BASE_FILE" ]; then
  error "Base constitution not found: $BASE_FILE"
  exit 1
fi

# --list: Show all workers
if [ "$1" = "--list" ] || [ "$1" = "-l" ]; then
  if [ ! -d "$WORKERS_DIR" ]; then
    error "Workers directory not found: $WORKERS_DIR"
    exit 1
  fi

  found=0
  echo "Available workers:"
  echo ""
  for file in "$WORKERS_DIR"/*.md; do
    if [ -f "$file" ]; then
      name=$(basename "$file" .md)
      if [ "$name" != "README" ]; then
        echo "  - $name"
        found=1
      fi
    fi
  done

  if [ "$found" -eq 0 ]; then
    echo "  (no workers found)"
  fi
  exit 0
fi

# --base: Show base constitution only
if [ "$1" = "--base" ] || [ "$1" = "-b" ]; then
  cat "$BASE_FILE"
  exit 0
fi

# No argument: show usage
if [ -z "$1" ]; then
  echo "Lexis - Constitution Viewer"
  echo ""
  echo "Usage:"
  echo "  lexis --list               List all workers"
  echo "  lexis <worker>             Show worker constitution"
  echo "  lexis --base               Show base constitution only"
  echo ""
  echo "Examples:"
  echo "  blueprint.sh lexis --list"
  echo "  blueprint.sh lexis orchestrator"
  echo "  blueprint.sh lexis specifier"
  exit 1
fi

WORKER="$1"
WORKER_FILE="$WORKERS_DIR/$WORKER.md"

# Check if worker exists
if [ ! -f "$WORKER_FILE" ]; then
  error "Worker constitution not found: $WORKER"
  echo ""
  echo "Available workers:"
  for file in "$WORKERS_DIR"/*.md; do
    if [ -f "$file" ]; then
      name=$(basename "$file" .md)
      if [ "$name" != "README" ]; then
        echo "  - $name"
      fi
    fi
  done
  exit 1
fi

# Show worker constitution only
# Note: Base constitution is loaded via SessionStart hook (session-init.sh)
cat "$WORKER_FILE"
