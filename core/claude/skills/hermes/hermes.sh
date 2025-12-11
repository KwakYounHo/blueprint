#!/bin/bash
# Hermes - Handoff Form Viewer
# View handoff forms between Workers
#
# Usage:
#   hermes --list                    List all handoff forms
#   hermes <from> <to>               Show specific handoff form

set -e

# Project root detection with fallback
PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../../.." && pwd)}"

FORMS_FILE="$PROJECT_ROOT/blueprint/forms/handoff.schema.md"

# Check if forms file exists
if [ ! -f "$FORMS_FILE" ]; then
  echo "[ERROR] Handoff forms not found: $FORMS_FILE"
  exit 1
fi

# --list: Show all available handoffs
if [ "$1" = "--list" ] || [ "$1" = "-l" ]; then
  echo "Available handoff forms:"
  echo ""

  found=0
  while read -r line; do
    from=$(echo "$line" | sed 's/\[F\]\([A-Za-z]*\)&\[T\].*/\1/')
    to=$(echo "$line" | sed 's/.*&\[T\]\([A-Za-z]*\)/\1/')
    echo "  - $from → $to"
    found=1
  done < <(grep -o '\[F\][A-Za-z]*&\[T\][A-Za-z]*' "$FORMS_FILE" 2>/dev/null)

  if [ "$found" -eq 0 ]; then
    echo "  (no handoff forms found)"
  fi
  exit 0
fi

# No argument: show usage
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Hermes - Handoff Form Viewer"
  echo ""
  echo "Usage:"
  echo "  hermes --list              List all handoff forms"
  echo "  hermes <from> <to>         Show specific handoff form"
  echo ""
  echo "Examples:"
  echo "  hermes --list"
  echo "  hermes orchestrator specifier"
  echo "  hermes specifier orchestrator"
  exit 1
fi

FROM="$1"
TO="$2"

# Capitalize first letter
FROM_CAP="$(echo "${FROM:0:1}" | tr '[:lower:]' '[:upper:]')${FROM:1}"
TO_CAP="$(echo "${TO:0:1}" | tr '[:lower:]' '[:upper:]')${TO:1}"

MARKER="[F]${FROM_CAP}&[T]${TO_CAP}"

# Check if marker exists
if ! grep -qF "$MARKER" "$FORMS_FILE"; then
  echo "[ERROR] Handoff form not found: $FROM_CAP → $TO_CAP"
  echo ""
  echo "Available forms:"
  grep -o '\[F\][A-Za-z]*&\[T\][A-Za-z]*' "$FORMS_FILE" | while read -r line; do
    f=$(echo "$line" | sed 's/\[F\]\([A-Za-z]*\)&\[T\].*/\1/')
    t=$(echo "$line" | sed 's/.*&\[T\]\([A-Za-z]*\)/\1/')
    echo "  - $f → $t"
  done
  exit 1
fi

# Extract content between ---s and ---e after the marker
awk -v from="$FROM_CAP" -v to="$TO_CAP" '
  $0 ~ "\\[F\\]" from "&\\[T\\]" to { found=1; next }
  found && /^---s$/ { start=1; next }
  found && /^---e$/ { exit }
  start { print }
' "$FORMS_FILE"
