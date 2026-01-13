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

# =============================================================================
# User-Level Path Resolution
# =============================================================================

# Convert absolute path to directory name
# Example: /Users/me/projects/blueprint → Users-me-projects-blueprint
# Example: /Users/me/Individual Project → Users-me-Individual-Project
path_to_dirname() {
  local path="$1"
  path="${path#/}"        # Remove leading /
  path="${path// /-}"     # Replace spaces with -
  echo "${path//\//-}"    # Replace / with -
}

# Get blueprint data directory for current project
# Returns: ~/.claude/blueprint/{project-path}/
get_blueprint_data_dir() {
  local project_path="${CLAUDE_PROJECT_DIR:-$(pwd)}"
  local dirname
  dirname=$(path_to_dirname "$project_path")
  echo "$HOME/.claude/blueprint/$dirname"
}

# Check if project is initialized for Blueprint
# Exits with error if not initialized
check_project_initialized() {
  local data_dir
  data_dir=$(get_blueprint_data_dir)

  if [ ! -d "$data_dir" ]; then
    error "Blueprint not initialized for this project."
    echo "" >&2
    echo "Project: ${CLAUDE_PROJECT_DIR:-$(pwd)}" >&2
    echo "Expected: $data_dir" >&2
    echo "" >&2
    echo "Run 'init-project.sh' to initialize Blueprint for this project." >&2
    exit 1
  fi
}

# Initialize BLUEPRINT_DATA_DIR for scripts that source this file
# Note: Does NOT check initialization - scripts should call check_project_initialized() if needed
BLUEPRINT_DATA_DIR="$(get_blueprint_data_dir)"

# =============================================================================
# FrontMatter Utilities
# =============================================================================

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
