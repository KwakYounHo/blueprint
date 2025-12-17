#!/bin/bash
# Blueprint Common Functions
# Source this file in submodule scripts
#
# Usage: source "$(dirname "$0")/../_common.sh"

# Project root detection with fallback
# When sourced from submodule: ../../.. goes to project root
# Path: .claude/skills/blueprint/_common.sh → ../../.. → project root
get_project_root() {
  if [ -n "$CLAUDE_PROJECT_DIR" ]; then
    echo "$CLAUDE_PROJECT_DIR"
  else
    # From .claude/skills/blueprint/_common.sh, go up 3 levels to project root
    cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd
  fi
}

# Initialize PROJECT_ROOT for scripts that source this file
PROJECT_ROOT="$(get_project_root)"

# Extract FrontMatter from file (between first and second ---)
# Supports both .md and .yaml files
get_frontmatter() {
  local file="$1"
  if [[ "$file" == *.yaml ]]; then
    # YAML: entire file is structured data
    cat "$file" 2>/dev/null
  else
    # Markdown: extract --- block
    awk '/^---$/{if(++c==2)exit}c' "$file" 2>/dev/null
  fi
}

# Extract field value from FrontMatter
get_field() {
  local frontmatter="$1"
  local field="$2"
  echo "$frontmatter" | grep "^${field}:" | sed "s/^${field}:[[:space:]]*//" | sed 's/^"//' | sed 's/"$//'
}

# Extract description from FrontMatter
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

# Print error message to stderr
error() {
  echo "[ERROR] $*" >&2
}

# Print info message
info() {
  echo "[INFO] $*"
}
