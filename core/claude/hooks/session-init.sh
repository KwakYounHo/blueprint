#!/bin/bash
# Session Initialization Hook
# Loads base constitution on session start/compact/clear
#
# Triggered by: SessionStart hook
# Input: JSON with session info including "source" field

set -e

# Project root detection with fallback
# From .claude/hooks/, go up 2 levels to project root
PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"

# Read JSON input from stdin
INPUT=$(cat)

# Extract source field using grep/sed (portable, no jq dependency)
SOURCE=$(echo "$INPUT" | grep -o '"source"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"source"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# Determine action based on source
case "$SOURCE" in
  startup|compact|clear)
    # Load base constitution for new/recovered sessions
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Loading Base Constitution"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    LEXIS_SCRIPT="$PROJECT_ROOT/.claude/skills/lexis/lexis.sh"

    if [ -f "$LEXIS_SCRIPT" ]; then
      "$LEXIS_SCRIPT" --base
    else
      echo "[WARN] Lexis script not found: $LEXIS_SCRIPT"
      echo "[INFO] Base constitution loading skipped."
    fi

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    ;;

  resume)
    # Resumed session - context should be preserved
    echo ""
    echo "[INFO] Session resumed. Context preserved."
    echo ""
    ;;

  *)
    # Unknown source - load base constitution to be safe
    echo ""
    echo "[WARN] Unknown session source: $SOURCE"
    echo "[INFO] Loading Base Constitution (safety measure)"
    echo ""

    LEXIS_SCRIPT="$PROJECT_ROOT/.claude/skills/lexis/lexis.sh"

    if [ -f "$LEXIS_SCRIPT" ]; then
      "$LEXIS_SCRIPT" --base
    fi
    ;;
esac

exit 0
