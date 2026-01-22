#!/bin/bash
# Session Initialization Hook
# Loads base constitution on session start/compact/clear for registered Blueprint projects
#
# Triggered by: SessionStart hook
# Input: JSON with session info including "source" field

set -e

# Read JSON input from stdin
INPUT=$(cat)

# Extract source field using grep/sed (portable, no jq dependency)
SOURCE=$(echo "$INPUT" | grep -o '"source"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"source"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# Blueprint CLI script path (user-level installation)
BLUEPRINT_SCRIPT="$HOME/.claude/skills/blueprint/blueprint.sh"

case "$SOURCE" in
  startup|compact|clear)
    if [ -f "$BLUEPRINT_SCRIPT" ]; then
      # Check if current directory is a registered Blueprint project
      if "$BLUEPRINT_SCRIPT" project current >/dev/null 2>&1; then
        # Registered project → Load framework + project constitutions + guidance
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Blueprint Project Detected"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        "$BLUEPRINT_SCRIPT" lexis --framework
        echo ""
        "$BLUEPRINT_SCRIPT" lexis --base
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "REQUIRED: Load '/blueprint' skill for Blueprint operations."
        echo "Project data is NOT in local directories - use skill commands."
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
    if [ -f "$BLUEPRINT_SCRIPT" ] && "$BLUEPRINT_SCRIPT" project current >/dev/null 2>&1; then
      echo ""
      echo "[WARN] Unknown session source: $SOURCE"
      echo "[INFO] Loading constitutions for Blueprint project."
      echo ""
      "$BLUEPRINT_SCRIPT" lexis --framework
      echo ""
      "$BLUEPRINT_SCRIPT" lexis --base
      echo ""
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "REQUIRED: Load '/blueprint' skill for Blueprint operations."
      echo "Project data is NOT in local directories - use skill commands."
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    fi
    ;;
esac

exit 0
