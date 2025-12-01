#!/bin/bash
# FrontMatter Schema Viewer
# View schema definitions for any document type
#
# Usage:
#   schema.sh <type>       Show schema for type
#   schema.sh --list       List available schemas

set -e

SCHEMA_DIR="blueprint/front-matters"

# --list: Show available schemas
if [ "$1" = "--list" ] || [ "$1" = "-l" ]; then
  echo "Available schemas:"
  echo ""
  for file in "$SCHEMA_DIR"/*.schema.md; do
    if [ -f "$file" ]; then
      name=$(basename "$file" .schema.md)
      echo "  - $name"
    fi
  done
  exit 0
fi

# No argument: show usage
if [ -z "$1" ]; then
  echo "Usage: schema.sh <type>"
  echo "       schema.sh --list"
  echo ""
  echo "Examples:"
  echo "  schema.sh task"
  echo "  schema.sh aspect"
  echo "  schema.sh --list"
  exit 1
fi

# Show specific schema
TYPE="$1"
SCHEMA_FILE="$SCHEMA_DIR/${TYPE}.schema.md"

if [ ! -f "$SCHEMA_FILE" ]; then
  echo "Schema not found: $TYPE"
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

cat "$SCHEMA_FILE"
