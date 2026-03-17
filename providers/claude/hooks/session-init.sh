#!/bin/bash
# Session Initialization Hook (Claude Code Provider)
# Loads base constitution on session start/compact/clear for registered Blueprint projects
#
# Triggered by: SessionStart hook in ~/.claude/settings.json
# Input: JSON with session info including "source" field

set -e

# Read JSON input from stdin
INPUT=$(cat)

# Extract source field using grep/sed (portable, no jq dependency)
SOURCE=$(echo "$INPUT" | grep -o '"source"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"source"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

case "$SOURCE" in
  startup|compact|clear)
    if command -v blueprint >/dev/null 2>&1; then
      # Check if current directory is a registered Blueprint project
      if blueprint project current >/dev/null 2>&1; then
        # Registered project → Load constitutions
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Blueprint Project Detected"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        blueprint lexis --framework
        echo ""
        blueprint lexis --base
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      else
        # Unregistered project → Simple notice
        echo ""
        echo "[INFO] This directory is not registered as a Blueprint project."
        echo ""
      fi
    fi
    ;;
  resume)
    echo ""
    echo "[INFO] Session resumed. Context preserved."
    echo ""
    ;;
  *)
    # Unknown source → Only check if registered, load constitutions
    if command -v blueprint >/dev/null 2>&1 && blueprint project current >/dev/null 2>&1; then
      echo ""
      echo "[WARN] Unknown session source: $SOURCE"
      echo "[INFO] Loading constitutions for Blueprint project."
      echo ""
      blueprint lexis --framework
      echo ""
      blueprint lexis --base
      echo ""
    fi
    ;;
esac

exit 0
