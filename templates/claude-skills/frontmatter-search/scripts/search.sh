#!/bin/bash
# FrontMatter Search Script
# Searches only in actual YAML FrontMatter block (not code block examples)
#
# Usage: search.sh <field> <value> [path]
# Example: search.sh type task blueprint/

set -e

FIELD="$1"
VALUE="$2"
SEARCH_PATH="${3:-.}"

if [ -z "$FIELD" ] || [ -z "$VALUE" ]; then
  echo "Usage: $0 <field> <value> [path]"
  echo ""
  echo "Examples:"
  echo "  $0 type task"
  echo "  $0 status active blueprint/"
  echo "  $0 type constitution blueprint/constitutions/"
  exit 1
fi

# Find all .md files and search FrontMatter only
find "$SEARCH_PATH" -name "*.md" -type f 2>/dev/null | while read -r file; do
  # Extract only the FrontMatter block (between first two ---)
  # awk: count --- lines, exit after 2nd one, print lines where count >= 1
  frontmatter=$(awk '/^---$/{if(++c==2)exit}c' "$file" 2>/dev/null)

  # Check if the field matches in FrontMatter
  if echo "$frontmatter" | grep -q "^${FIELD}: *${VALUE}"; then
    echo "$file"
  fi
done
