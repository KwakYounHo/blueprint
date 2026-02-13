#!/bin/bash
# Blueprint Project Submodule
# Manage project aliases for cross-machine portability
#
# Usage: blueprint project <command> [args]

set -e

source "$(dirname "$0")/../_common.sh"

COMMAND="$1"

# =============================================================================
# Help
# =============================================================================

show_help() {
  cat << 'EOF'
Project - Manage project aliases for cross-machine portability

Usage:
  blueprint project init <alias> [--type bare|repo] [--notes "text"]
                                                    Initialize new project
  blueprint project setup [alias] [--all]           Provision config to project paths
  blueprint project sync [--dry-run] [--force]      Sync templates/schemas from base
  blueprint project list                            List all projects
  blueprint project show <alias>                    Show project details
  blueprint project remove <alias>                  Remove project
  blueprint project link <alias>                    Link current path to project
  blueprint project unlink <alias> [path]           Unlink path from project
  blueprint project rename <new-alias>              Rename project alias
  blueprint project manage                          Scan and manage projects
  blueprint project current [--data]                Show current project info

Options:
  -h, --help    Show this help message

Examples:
  blueprint project init myproject
  blueprint project init myproject --type bare --notes "Bare repo project"
  blueprint project setup
  blueprint project setup myproject
  blueprint project setup --all
  blueprint project sync --dry-run
  blueprint project sync --force
  blueprint project list
  blueprint project show myproject
  blueprint project link myproject
  blueprint project unlink myproject /old/path
  blueprint project rename my-new-alias
  blueprint project manage
  blueprint project current
  blueprint project current --data
EOF
}

# =============================================================================
# Utility Functions
# =============================================================================

require_jq() {
  if ! command -v jq &> /dev/null; then
    error "jq is required for project management."
    echo "Install jq: https://stedolan.github.io/jq/download/"
    exit 1
  fi
}

# =============================================================================
# Commands
# =============================================================================

do_init() {
  local alias_name="$1"
  shift || true
  local notes=""
  local project_type="repo"

  # Parse flags
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --notes)
        notes="$2"
        shift 2
        ;;
      --type)
        project_type="$2"
        if [[ "$project_type" != "bare" && "$project_type" != "repo" ]]; then
          error "Invalid type '$project_type'. Must be 'bare' or 'repo'."
          exit 1
        fi
        shift 2
        ;;
      *)
        error "Unknown option: $1"
        exit 1
        ;;
    esac
  done

  if [ -z "$alias_name" ]; then
    echo "Usage: blueprint project init <alias> [--type bare|repo] [--notes \"text\"]"
    exit 1
  fi

  require_jq

  local current_path
  current_path="${CLAUDE_PROJECT_DIR:-$(pwd)}"

  # For bare type: resolve to wrapper directory
  if [ "$project_type" = "bare" ]; then
    local wrapper_dir
    wrapper_dir=$(resolve_bare_wrapper_dir)
    if [ -n "$wrapper_dir" ]; then
      current_path="$wrapper_dir"
    fi
  fi

  # Validate alias format
  if ! [[ "$alias_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    error "Invalid alias. Use alphanumeric characters, dashes, and underscores only."
    exit 1
  fi

  # Initialize registry if needed
  init_registry

  # Check if path already registered
  local existing_alias
  existing_alias=$(resolve_project_alias "$current_path")
  if [ -n "$existing_alias" ]; then
    error "Path already registered as '$existing_alias'."
    echo "Use 'blueprint project show $existing_alias' to view details."
    exit 1
  fi

  # Check if alias exists
  if jq -e --arg a "$alias_name" '.projects[] | select(.alias == $a)' "$BLUEPRINT_REGISTRY" >/dev/null 2>&1; then
    error "Alias '$alias_name' already exists."
    echo "Use 'blueprint project link $alias_name' to add current path."
    exit 1
  fi

  local data_dir="$HOME/.claude/blueprint/projects/$alias_name"

  # Check for legacy directory
  local legacy_dirname
  legacy_dirname=$(path_to_dirname "$current_path")
  local legacy_dir="$HOME/.claude/blueprint/projects/$legacy_dirname"

  if [ -d "$legacy_dir" ] && [ ! -d "$data_dir" ]; then
    info "Found existing data at $legacy_dir"
    info "Renaming to $data_dir"
    mv "$legacy_dir" "$data_dir"
  elif [ ! -d "$data_dir" ]; then
    # Create new data directory with all required subdirectories
    mkdir -p "$data_dir/constitutions"
    mkdir -p "$data_dir/forms"
    mkdir -p "$data_dir/front-matters"
    mkdir -p "$data_dir/gates"
    mkdir -p "$data_dir/templates"
    mkdir -p "$data_dir/plans"

    # Try to copy framework files from various sources
    local source_dir=""
    local base_dir="$HOME/.claude/blueprint/base"

    # Check user-level base files first (from install-global.sh)
    if [ -d "$base_dir/constitutions" ]; then
      source_dir="$base_dir"
    # Check environment variable
    elif [ -n "${BLUEPRINT_FRAMEWORK_DIR:-}" ] && [ -d "$BLUEPRINT_FRAMEWORK_DIR/core" ]; then
      source_dir="$BLUEPRINT_FRAMEWORK_DIR/core"
    # Check project root (for development)
    elif [ -d "$PROJECT_ROOT/core" ]; then
      source_dir="$PROJECT_ROOT/core"
    fi

    if [ -n "$source_dir" ]; then
      [ -d "$source_dir/constitutions" ] && rsync -a "$source_dir/constitutions/" "$data_dir/constitutions/"
      [ -d "$source_dir/forms" ] && rsync -a "$source_dir/forms/" "$data_dir/forms/"
      [ -d "$source_dir/front-matters" ] && rsync -a "$source_dir/front-matters/" "$data_dir/front-matters/"
      [ -d "$source_dir/gates" ] && rsync -a "$source_dir/gates/" "$data_dir/gates/"
      [ -d "$source_dir/templates" ] && rsync -a "$source_dir/templates/" "$data_dir/templates/"
    fi
  fi

  # Add to registry
  local tmp_file
  tmp_file=$(mktemp)
  jq --arg alias "$alias_name" \
     --arg path "$current_path" \
     --arg notes "$notes" \
     --arg type "$project_type" \
     '.projects += [{"alias": $alias, "type": $type, "paths": [$path], "notes": $notes}]' \
     "$BLUEPRINT_REGISTRY" > "$tmp_file" && mv "$tmp_file" "$BLUEPRINT_REGISTRY"

  echo ""
  info "Project initialized: $alias_name"
  echo "  Type: $project_type"
  echo "  Path: $current_path"
  echo "  Data: $data_dir"
  [ -n "$notes" ] && echo "  Notes: $notes"
}

do_list() {
  require_jq
  init_registry

  local count
  count=$(jq '.projects | length' "$BLUEPRINT_REGISTRY")

  if [ "$count" -eq 0 ]; then
    echo "No projects registered."
    echo ""
    echo "Run 'blueprint project init <alias>' to register a project."
    exit 0
  fi

  echo "Projects ($count):"
  echo ""

  jq -r '.projects[] | "\(.alias)\t\(.type // "repo")\t\(.paths | length)\t\(.notes // "-")"' "$BLUEPRINT_REGISTRY" | \
    while IFS=$'\t' read -r alias_name type_val paths notes; do
      printf "  %-16s [%-4s] (%d paths)  %s\n" "$alias_name" "$type_val" "$paths" "$notes"
    done
}

do_show() {
  local alias_name="$1"

  if [ -z "$alias_name" ]; then
    echo "Usage: blueprint project show <alias>"
    exit 1
  fi

  require_jq
  init_registry

  local project
  project=$(jq -e --arg a "$alias_name" '.projects[] | select(.alias == $a)' "$BLUEPRINT_REGISTRY" 2>/dev/null)

  if [ -z "$project" ]; then
    error "Project '$alias_name' not found."
    echo ""
    echo "Available projects:"
    do_list
    exit 1
  fi

  echo "Project: $alias_name"
  echo "Type: $(echo "$project" | jq -r '.type // "repo"')"
  echo "Notes: $(echo "$project" | jq -r '.notes // "-"')"
  echo "Paths:"
  echo "$project" | jq -r '.paths[]' | while read -r path; do
    echo "  - $path"
  done
  echo "Data: ~/.claude/blueprint/projects/$alias_name/"
}

do_remove() {
  local alias_name=""
  local remove_registry=false
  local remove_data_dir=false

  # Parse arguments
  while [ $# -gt 0 ]; do
    case "$1" in
      --registry)
        remove_registry=true
        shift
        ;;
      --data-dir)
        remove_data_dir=true
        shift
        ;;
      -*)
        error "Unknown option: $1"
        exit 1
        ;;
      *)
        alias_name="$1"
        shift
        ;;
    esac
  done

  if [ -z "$alias_name" ]; then
    echo "Usage: blueprint project remove <alias> --registry [--data-dir]"
    exit 1
  fi

  require_jq
  init_registry

  # Check exists
  if ! jq -e --arg a "$alias_name" '.projects[] | select(.alias == $a)' "$BLUEPRINT_REGISTRY" >/dev/null 2>&1; then
    error "Project '$alias_name' not found."
    exit 1
  fi

  if [ "$remove_registry" = false ]; then
    error "Specify what to remove:"
    echo "  blueprint project remove $alias_name --registry             # Registry only"
    echo "  blueprint project remove $alias_name --registry --data-dir  # Registry + data"
    exit 1
  fi

  # Delete data directory if requested
  local data_dir="$HOME/.claude/blueprint/projects/$alias_name"
  if [ "$remove_data_dir" = true ] && [ -d "$data_dir" ]; then
    rm -rf "$data_dir"
    info "Data directory deleted."
  fi

  # Remove from registry
  local tmp_file
  tmp_file=$(mktemp)
  jq --arg a "$alias_name" 'del(.projects[] | select(.alias == $a))' "$BLUEPRINT_REGISTRY" > "$tmp_file" && mv "$tmp_file" "$BLUEPRINT_REGISTRY"

  info "Project '$alias_name' removed from registry."
}

do_link() {
  local alias_name="$1"
  local current_path
  current_path="${CLAUDE_PROJECT_DIR:-$(pwd)}"

  if [ -z "$alias_name" ]; then
    echo "Usage: blueprint project link <alias>"
    exit 1
  fi

  require_jq
  init_registry

  # Check alias exists
  if ! jq -e --arg a "$alias_name" '.projects[] | select(.alias == $a)' "$BLUEPRINT_REGISTRY" >/dev/null 2>&1; then
    error "Project '$alias_name' not found."
    echo ""
    echo "Available projects:"
    do_list
    exit 1
  fi

  # If project is bare type, resolve to wrapper directory
  local project_type
  project_type=$(get_project_type "$alias_name")
  if [ "$project_type" = "bare" ]; then
    local wrapper_dir
    wrapper_dir=$(resolve_bare_wrapper_dir)
    if [ -n "$wrapper_dir" ]; then
      current_path="$wrapper_dir"
    fi
  fi

  # Check path not already linked
  local existing
  existing=$(jq -r --arg a "$alias_name" --arg p "$current_path" \
    '.projects[] | select(.alias == $a) | .paths[] | select(. == $p)' "$BLUEPRINT_REGISTRY")

  if [ -n "$existing" ]; then
    error "Path already linked to '$alias_name'."
    exit 1
  fi

  # Add path
  local tmp_file
  tmp_file=$(mktemp)
  jq --arg a "$alias_name" --arg p "$current_path" \
    '(.projects[] | select(.alias == $a) | .paths) += [$p]' \
    "$BLUEPRINT_REGISTRY" > "$tmp_file" && mv "$tmp_file" "$BLUEPRINT_REGISTRY"

  info "Path linked to '$alias_name'."
  echo "  $current_path"
}

do_unlink() {
  local alias_name="$1"
  local path="${2:-${CLAUDE_PROJECT_DIR:-$(pwd)}}"

  if [ -z "$alias_name" ]; then
    echo "Usage: blueprint project unlink <alias> [path]"
    exit 1
  fi

  require_jq
  init_registry

  # If no explicit path given and project is bare type, resolve to wrapper directory
  if [ -z "$2" ]; then
    local project_type
    project_type=$(get_project_type "$alias_name")
    if [ "$project_type" = "bare" ]; then
      local wrapper_dir
      wrapper_dir=$(resolve_bare_wrapper_dir)
      if [ -n "$wrapper_dir" ]; then
        path="$wrapper_dir"
      fi
    fi
  fi

  # Check alias exists
  local project
  project=$(jq -e --arg a "$alias_name" '.projects[] | select(.alias == $a)' "$BLUEPRINT_REGISTRY" 2>/dev/null)

  if [ -z "$project" ]; then
    error "Project '$alias_name' not found."
    exit 1
  fi

  # Check path count
  local path_count
  path_count=$(echo "$project" | jq '.paths | length')

  if [ "$path_count" -eq 1 ]; then
    echo "Warning: This is the last path for '$alias_name'."
    read -p "Remove project entirely? [y/N] " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      do_remove "$alias_name" --registry
      return
    else
      echo "Cancelled."
      exit 0
    fi
  fi

  # Remove path
  local tmp_file
  tmp_file=$(mktemp)
  jq --arg a "$alias_name" --arg p "$path" \
    '(.projects[] | select(.alias == $a) | .paths) -= [$p]' \
    "$BLUEPRINT_REGISTRY" > "$tmp_file" && mv "$tmp_file" "$BLUEPRINT_REGISTRY"

  info "Path unlinked from '$alias_name'."
}

do_rename() {
  local new_alias="$1"
  local current_path="${CLAUDE_PROJECT_DIR:-$(pwd)}"

  if [ -z "$new_alias" ]; then
    echo "Usage: blueprint project rename <new-alias>"
    exit 1
  fi

  require_jq

  # Validate new alias format
  if ! [[ "$new_alias" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    error "Invalid alias. Use alphanumeric characters, dashes, and underscores only."
    exit 1
  fi

  init_registry

  # Check new alias not already taken
  if jq -e --arg a "$new_alias" '.projects[] | select(.alias == $a)' "$BLUEPRINT_REGISTRY" >/dev/null 2>&1; then
    error "Alias '$new_alias' already exists."
    exit 1
  fi

  # Try bare wrapper dir resolution for path matching
  local wrapper_dir
  wrapper_dir=$(resolve_bare_wrapper_dir)
  if [ -n "$wrapper_dir" ]; then
    local alias_try
    alias_try=$(resolve_project_alias "$wrapper_dir")
    if [ -n "$alias_try" ]; then
      current_path="$wrapper_dir"
    fi
  fi

  # Find current project by path
  local current_alias
  current_alias=$(resolve_project_alias "$current_path")

  local old_dir=""
  local is_registered=false

  if [ -n "$current_alias" ]; then
    # Project is registered
    is_registered=true
    old_dir="$HOME/.claude/blueprint/projects/$current_alias"
  else
    # Project not registered - check for legacy path-based directory
    local legacy_dirname
    legacy_dirname=$(path_to_dirname "$current_path")
    local legacy_dir="$HOME/.claude/blueprint/projects/$legacy_dirname"

    if [ -d "$legacy_dir" ]; then
      old_dir="$legacy_dir"
      current_alias="$legacy_dirname"
    else
      error "No project data found for current path."
      echo "Use 'blueprint project init $new_alias' to create a new project."
      exit 1
    fi
  fi

  local new_dir="$HOME/.claude/blueprint/projects/$new_alias"

  # Rename data directory
  if [ "$old_dir" != "$new_dir" ]; then
    if [ -d "$new_dir" ]; then
      error "Directory already exists: $new_dir"
      exit 1
    fi
    mv "$old_dir" "$new_dir"
    info "Renamed: $old_dir → $new_dir"
  fi

  # Update or create registry entry
  local tmp_file
  tmp_file=$(mktemp)

  if [ "$is_registered" = true ]; then
    # Update existing entry
    jq --arg old "$current_alias" --arg new "$new_alias" \
      '(.projects[] | select(.alias == $old) | .alias) = $new' \
      "$BLUEPRINT_REGISTRY" > "$tmp_file" && mv "$tmp_file" "$BLUEPRINT_REGISTRY"
  else
    # Create new entry for unregistered project
    local detected_type="repo"
    if [ -n "$wrapper_dir" ]; then
      detected_type="bare"
    fi
    jq --arg alias "$new_alias" --arg path "$current_path" --arg type "$detected_type" \
      '.projects += [{"alias": $alias, "type": $type, "paths": [$path], "notes": ""}]' \
      "$BLUEPRINT_REGISTRY" > "$tmp_file" && mv "$tmp_file" "$BLUEPRINT_REGISTRY"
  fi

  echo ""
  info "Project renamed: $current_alias → $new_alias"
  echo "  Path: $current_path"
  echo "  Data: $new_dir"
}

do_current() {
  local show_data=false

  # Parse flags
  while [ $# -gt 0 ]; do
    case "$1" in
      --data)
        show_data=true
        shift
        ;;
      -*)
        error "Unknown option: $1"
        exit 1
        ;;
      *)
        shift
        ;;
    esac
  done

  local current_path
  current_path=$(get_project_path)
  local data_dir
  data_dir=$(get_blueprint_data_dir "$current_path")

  # Check if project exists
  if [ ! -d "$data_dir" ]; then
    error "No project data found for current path."
    echo "Run 'blueprint project init <alias>' to initialize."
    exit 1
  fi

  local alias_name
  alias_name=$(resolve_project_alias "$current_path")
  if [ -z "$alias_name" ]; then
    alias_name=$(basename "$data_dir")
  fi

  # Output based on flags
  if [ "$show_data" = true ]; then
    echo "$data_dir"
  else
    echo "Alias: $alias_name"
    echo "Data: $data_dir"
  fi
}

# =============================================================================
# Setup Functions
# =============================================================================

# Create a symlink with conflict handling.
# Args: $1=source $2=target $3=display_name
# Returns: 0=created, 1=skipped, 2=warned
_try_symlink() {
  local source_path="$1"
  local target_path="$2"
  local display_name="$3"

  if [ ! -e "$source_path" ]; then
    printf "      %-14s ! missing source\n" "$display_name"
    return 2
  fi

  # Correct symlink already exists
  if [ -L "$target_path" ]; then
    local current_target
    current_target="$(readlink "$target_path")"
    if [ "$current_target" = "$source_path" ]; then
      printf "      %-14s - skip (already linked)\n" "$display_name"
      return 1
    fi
    ln -sfn "$source_path" "$target_path"
    printf "      %-14s + relinked\n" "$display_name"
    return 0
  fi

  # Real file or directory exists (not a symlink)
  if [ -e "$target_path" ]; then
    printf "      %-14s ! conflict (real file exists)\n" "$display_name"
    return 2
  fi

  # Nothing exists — create symlink
  ln -s "$source_path" "$target_path"
  printf "      %-14s + linked\n" "$display_name"
  return 0
}

# Provision config and plansDirectory for a single target path.
# Args: $1=config_dir $2=target_path $3=plans_dir
# Modifies counters: sl_created, sl_skipped, sl_warned, pd_created, pd_updated, pd_skipped
_setup_target_path() {
  local config_dir="$1"
  local target_path="$2"
  local plans_dir="$3"

  if [ ! -d "$target_path" ]; then
    printf "      - skip (path not found)\n"
    sl_skipped=$((sl_skipped + 1))
    return 0
  fi

  # ----- Symlinks -----
  if [ -f "$config_dir/CLAUDE.md" ]; then
    local result=0
    _try_symlink "$config_dir/CLAUDE.md" "$target_path/CLAUDE.md" "CLAUDE.md" || result=$?
    case $result in
      0) sl_created=$((sl_created + 1)) ;;
      1) sl_skipped=$((sl_skipped + 1)) ;;
      2) sl_warned=$((sl_warned + 1)) ;;
    esac
  fi

  if [ -d "$config_dir/.claude" ]; then
    local result=0
    _try_symlink "$config_dir/.claude" "$target_path/.claude" ".claude/" || result=$?
    case $result in
      0) sl_created=$((sl_created + 1)) ;;
      1) sl_skipped=$((sl_skipped + 1)) ;;
      2) sl_warned=$((sl_warned + 1)) ;;
    esac
  fi

  # ----- plansDirectory injection -----
  mkdir -p "$plans_dir"

  local local_claude_dir="$target_path/.claude"
  if [ ! -d "$local_claude_dir" ] && [ ! -L "$local_claude_dir" ]; then
    mkdir -p "$local_claude_dir"
  fi

  local settings_file="$local_claude_dir/settings.local.json"

  if [ -f "$settings_file" ]; then
    local existing_pd
    existing_pd=$(jq -r '.plansDirectory // ""' "$settings_file" 2>/dev/null || echo "")
    if [ "$existing_pd" = "$plans_dir" ]; then
      printf "      %-14s - skip (already set)\n" "plansDirectory"
      pd_skipped=$((pd_skipped + 1))
    else
      local tmp_file
      tmp_file=$(mktemp)
      jq --arg pd "$plans_dir" '.plansDirectory = $pd' "$settings_file" > "$tmp_file"
      mv "$tmp_file" "$settings_file"
      if [ -z "$existing_pd" ]; then
        printf "      %-14s + added\n" "plansDirectory"
        pd_created=$((pd_created + 1))
      else
        printf "      %-14s + updated\n" "plansDirectory"
        pd_updated=$((pd_updated + 1))
      fi
    fi
  else
    printf '{\n  "plansDirectory": "%s"\n}\n' "$plans_dir" > "$settings_file"
    printf "      %-14s + created (new settings.local.json)\n" "plansDirectory"
    pd_created=$((pd_created + 1))
  fi
}

# Provision a single project across all its paths/worktrees.
# Args: $1=alias_name
# Modifies counters: sl_created, sl_skipped, sl_warned, pd_created, pd_updated, pd_skipped
_setup_project() {
  local alias_name="$1"
  local project_type
  project_type=$(get_project_type "$alias_name")
  local config_dir="$HOME/.claude/blueprint/projects/$alias_name/config"
  local plans_dir="$HOME/.claude/blueprint/projects/$alias_name/claude-plans"

  echo "  [$alias_name] (type: $project_type)"

  if [ ! -d "$config_dir" ]; then
    echo "    config: not found ($config_dir)"
    echo "    - skip (no config data to provision)"
    echo ""
    return 0
  fi

  local path_count
  path_count=$(jq -r --arg a "$alias_name" \
    '.projects[] | select(.alias == $a) | .paths | length' "$BLUEPRINT_REGISTRY")

  for j in $(seq 0 $((path_count - 1))); do
    local project_path
    project_path=$(jq -r --arg a "$alias_name" \
      ".projects[] | select(.alias == \$a) | .paths[$j]" "$BLUEPRINT_REGISTRY")

    if [ ! -d "$project_path" ]; then
      echo "    path: $project_path"
      printf "      - skip (path not found on this machine)\n"
      sl_skipped=$((sl_skipped + 1))
      continue
    fi

    if [ "$project_type" = "bare" ]; then
      echo "    wrapper: $project_path"
      local worktree_count=0
      while IFS= read -r wt_path; do
        [ -z "$wt_path" ] && continue
        echo "    worktree: $wt_path"
        _setup_target_path "$config_dir" "$wt_path" "$plans_dir"
        worktree_count=$((worktree_count + 1))
      done < <(list_worktrees "$project_path")
      if [ "$worktree_count" -eq 0 ]; then
        printf "      - skip (no worktrees found)\n"
      fi
    else
      echo "    path: $project_path"
      _setup_target_path "$config_dir" "$project_path" "$plans_dir"
    fi
  done
  echo ""
}

do_setup() {
  local target_alias=""
  local setup_all=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --all)
        setup_all=true
        shift
        ;;
      -*)
        error "Unknown option: $1"
        exit 1
        ;;
      *)
        target_alias="$1"
        shift
        ;;
    esac
  done

  require_jq
  init_registry

  # Counters
  local sl_created=0 sl_skipped=0 sl_warned=0
  local pd_created=0 pd_updated=0 pd_skipped=0

  echo ""
  echo "Project Setup"
  echo ""

  if [ "$setup_all" = true ]; then
    local project_count
    project_count=$(jq '.projects | length' "$BLUEPRINT_REGISTRY")
    if [ "$project_count" -eq 0 ]; then
      info "No projects registered."
      return 0
    fi
    for i in $(seq 0 $((project_count - 1))); do
      local alias_name
      alias_name=$(jq -r ".projects[$i].alias" "$BLUEPRINT_REGISTRY")
      _setup_project "$alias_name"
    done
  elif [ -n "$target_alias" ]; then
    if ! jq -e --arg a "$target_alias" '.projects[] | select(.alias == $a)' "$BLUEPRINT_REGISTRY" >/dev/null 2>&1; then
      error "Project '$target_alias' not found."
      exit 1
    fi
    _setup_project "$target_alias"
  else
    local current_alias
    current_alias=$(resolve_project_alias)
    if [ -z "$current_alias" ]; then
      error "No project found for current path."
      echo "Run 'blueprint project init <alias>' to register."
      exit 1
    fi
    _setup_project "$current_alias"
  fi

  echo "  Symlinks: $sl_created created, $sl_skipped unchanged, $sl_warned warnings."
  echo "  plansDirectory: $pd_created created, $pd_updated updated, $pd_skipped unchanged."
}

# =============================================================================
# Sync Functions
# =============================================================================

# Compare semver versions: returns 0 if $1 > $2
version_gt() {
  [ "$1" = "$2" ] && return 1
  local higher
  higher=$(printf '%s\n' "$1" "$2" | sort -V | tail -n1)
  [ "$higher" = "$1" ]
}

# Compare dates (YYYY-MM-DD): returns 0 if $1 > $2
date_gt() {
  [ "$1" = "$2" ] && return 1
  [ "$1" \> "$2" ]
}

# Get version from file's FrontMatter
get_file_version() {
  local file="$1"
  local fm
  fm=$(get_frontmatter "$file")
  local ver
  ver=$(get_field "$fm" "version")
  echo "${ver:-0.0.0}"
}

# Get updated date from file's FrontMatter
get_file_updated() {
  local file="$1"
  local fm
  fm=$(get_frontmatter "$file")
  local upd
  upd=$(get_field "$fm" "updated")
  echo "${upd:-1970-01-01}"
}

# Compare two files and return status
# Returns: NEW, UPDATE, PATCH, DIFFERS, OK, CUSTOMIZED
compare_files() {
  local base_file="$1"
  local project_file="$2"

  # File doesn't exist in project
  if [ ! -f "$project_file" ]; then
    echo "NEW"
    return
  fi

  local base_ver project_ver
  base_ver=$(get_file_version "$base_file")
  project_ver=$(get_file_version "$project_file")

  # Version comparison
  if version_gt "$base_ver" "$project_ver"; then
    echo "UPDATE"
    return
  elif version_gt "$project_ver" "$base_ver"; then
    echo "CUSTOMIZED"
    return
  fi

  # Same version - compare updated date
  local base_upd project_upd
  base_upd=$(get_file_updated "$base_file")
  project_upd=$(get_file_updated "$project_file")

  if date_gt "$base_upd" "$project_upd"; then
    echo "PATCH"
  elif date_gt "$project_upd" "$base_upd"; then
    echo "CUSTOMIZED"
  else
    # Same version and updated - check content with checksum
    local base_hash project_hash
    base_hash=$(md5 -q "$base_file" 2>/dev/null || md5sum "$base_file" | cut -d' ' -f1)
    project_hash=$(md5 -q "$project_file" 2>/dev/null || md5sum "$project_file" | cut -d' ' -f1)

    if [ "$base_hash" != "$project_hash" ]; then
      echo "DIFFERS"
    else
      echo "OK"
    fi
  fi
}

# Sync a single directory (recursive)
sync_directory() {
  local base_path="$1"
  local project_path="$2"
  local dry_run="$3"
  local force="$4"
  local rel_path="${5:-}"

  [ ! -d "$base_path" ] && return

  # Ensure project directory exists
  if [ "$dry_run" = false ]; then
    mkdir -p "$project_path"
  fi

  # Process files
  for base_file in "$base_path"/*; do
    [ ! -e "$base_file" ] && continue

    local filename
    filename=$(basename "$base_file")
    local project_file="$project_path/$filename"
    local display_path="${rel_path:+$rel_path/}$filename"

    # Handle subdirectories recursively
    if [ -d "$base_file" ]; then
      sync_directory "$base_file" "$project_file" "$dry_run" "$force" "$display_path"
      continue
    fi

    # Compare files
    local status
    status=$(compare_files "$base_file" "$project_file")

    case "$status" in
      NEW)
        if [ "$dry_run" = true ]; then
          echo "  [NEW]        $display_path"
        else
          cp "$base_file" "$project_file"
          echo "  [NEW]        $display_path (copied)"
        fi
        ;;
      UPDATE)
        local base_ver project_ver
        base_ver=$(get_file_version "$base_file")
        project_ver=$(get_file_version "$project_file")
        if [ "$force" = true ]; then
          if [ "$dry_run" = true ]; then
            echo "  [UPDATE]     $display_path ($project_ver → $base_ver)"
          else
            cp "$base_file" "$project_file"
            echo "  [UPDATE]     $display_path ($project_ver → $base_ver) (updated)"
          fi
        else
          echo "  [UPDATE]     $display_path ($project_ver → $base_ver available, use --force)"
        fi
        ;;
      PATCH)
        local base_upd project_upd
        base_upd=$(get_file_updated "$base_file")
        project_upd=$(get_file_updated "$project_file")
        if [ "$force" = true ]; then
          if [ "$dry_run" = true ]; then
            echo "  [PATCH]      $display_path ($project_upd → $base_upd)"
          else
            cp "$base_file" "$project_file"
            echo "  [PATCH]      $display_path ($project_upd → $base_upd) (patched)"
          fi
        else
          echo "  [PATCH]      $display_path ($project_upd → $base_upd available, use --force)"
        fi
        ;;
      CUSTOMIZED)
        echo "  [CUSTOMIZED] $display_path (skipped - project version is newer)"
        ;;
      DIFFERS)
        echo "  [DIFFERS]    $display_path (same version/date but content differs)"
        if [ "$force" = true ]; then
          if [ "$dry_run" = false ]; then
            cp "$base_file" "$project_file"
            echo "               → overwritten with base version"
          fi
        else
          echo "               → review manually or use --force to overwrite"
        fi
        ;;
      OK)
        # Silent for OK files unless verbose
        ;;
    esac
  done
}

do_sync() {
  local dry_run=false
  local force=false

  # Parse flags
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run)
        dry_run=true
        shift
        ;;
      --force)
        force=true
        shift
        ;;
      *)
        error "Unknown option: $1"
        exit 1
        ;;
    esac
  done

  check_project_initialized

  local base_dir="$HOME/.claude/blueprint/base"
  local project_dir="$BLUEPRINT_DATA_DIR"

  # Verify base directory exists
  if [ ! -d "$base_dir" ]; then
    error "Base directory not found: $base_dir"
    echo "Run 'install-global.sh' to set up Blueprint base files."
    exit 1
  fi

  echo "Syncing from: $base_dir"
  echo "          to: $project_dir"
  [ "$dry_run" = true ] && echo "(dry-run mode - no changes will be made)"
  echo ""

  # Directories to sync (plans is excluded - project-specific data)
  local sync_dirs=("constitutions" "forms" "front-matters" "gates" "templates")

  for dir in "${sync_dirs[@]}"; do
    if [ -d "$base_dir/$dir" ]; then
      echo "$dir/"
      sync_directory "$base_dir/$dir" "$project_dir/$dir" "$dry_run" "$force" "$dir"
    fi
  done

  echo ""
  if [ "$dry_run" = true ]; then
    info "Dry run complete. Use without --dry-run to apply changes."
  else
    info "Sync complete."
  fi

  # Show protection tip
  echo ""
  echo "Tip: To protect customized files from future syncs, update their 'version'"
  echo "     or 'updated' field to a value higher than the base file."
}

do_manage() {
  require_jq
  init_registry

  local blueprint_dir="$HOME/.claude/blueprint/projects"
  local unregistered_count=0
  local pathbased_count=0
  local unregistered_valid=()
  local unregistered_invalid=()
  local pathbased_projects=()

  echo "Scanning projects..."
  echo ""

  # Required directories for valid structure
  local required_dirs=("constitutions" "forms" "front-matters" "gates" "templates" "plans")

  # Step 1: Scan for unregistered projects
  for dir in "$blueprint_dir"/*/; do
    [ -d "$dir" ] || continue

    local dirname
    dirname=$(basename "$dir")

    # Skip registry file and hidden dirs
    [[ "$dirname" == "."* ]] && continue

    # Check if registered
    local is_registered
    is_registered=$(jq -r --arg a "$dirname" '.projects[] | select(.alias == $a) | .alias' "$BLUEPRINT_REGISTRY" 2>/dev/null)

    if [ -z "$is_registered" ]; then
      # Unregistered - validate structure
      local missing_dirs=()
      for req_dir in "${required_dirs[@]}"; do
        [ ! -d "$dir$req_dir" ] && missing_dirs+=("$req_dir/")
      done

      if [ ${#missing_dirs[@]} -eq 0 ]; then
        unregistered_valid+=("$dirname")
      else
        unregistered_invalid+=("$dirname:${missing_dirs[*]}")
      fi
      ((unregistered_count++))
    else
      # Registered - check if path-based alias
      # Path-based aliases contain multiple dashes and typically start with capital letter
      if [[ "$dirname" =~ ^[A-Z][a-zA-Z0-9]*-[a-zA-Z0-9]+-.*$ ]]; then
        pathbased_projects+=("$dirname")
        ((pathbased_count++))
      fi
    fi
  done

  # Output unregistered projects
  if [ ${#unregistered_valid[@]} -gt 0 ] || [ ${#unregistered_invalid[@]} -gt 0 ]; then
    echo "Unregistered Projects ($unregistered_count):"
    echo ""

    for proj in "${unregistered_valid[@]}"; do
      # Suggest alias from directory name
      local suggested
      suggested=$(echo "$proj" | sed 's/.*-//' | tr '[:upper:]' '[:lower:]')
      echo "  $proj/"
      echo "    Status: Valid structure"
      echo "    Suggested alias: $suggested"
      echo "    Action: Run 'blueprint project rename $suggested'"
      echo ""
    done

    for entry in "${unregistered_invalid[@]}"; do
      local proj="${entry%%:*}"
      local missing="${entry#*:}"
      echo "  $proj/"
      echo "    Status: Invalid (missing: $missing)"
      echo "    Action: Consider cleanup or manual repair"
      echo ""
    done
  fi

  # Output path-based registered projects
  if [ ${#pathbased_projects[@]} -gt 0 ]; then
    echo "path-based Registered Projects ($pathbased_count):"
    echo ""

    for proj in "${pathbased_projects[@]}"; do
      local suggested
      suggested=$(echo "$proj" | sed 's/.*-//' | tr '[:upper:]' '[:lower:]')
      echo "  $proj/"
      echo "    Current alias: $proj"
      echo "    Suggested alias: $suggested"
      echo "    Action: Run 'blueprint project rename $suggested'"
      echo ""
    done
  fi

  # Summary
  echo "Summary: $unregistered_count unregistered, $pathbased_count path-based"

  if [ $unregistered_count -eq 0 ] && [ $pathbased_count -eq 0 ]; then
    echo ""
    info "All projects are properly registered with custom aliases."
  fi
}

# =============================================================================
# Main Dispatch
# =============================================================================

case "$COMMAND" in
  init)
    shift
    do_init "$@"
    ;;
  setup)
    shift
    do_setup "$@"
    ;;
  sync)
    shift
    do_sync "$@"
    ;;
  list)
    do_list
    ;;
  show)
    shift
    do_show "$@"
    ;;
  remove)
    shift
    do_remove "$@"
    ;;
  link)
    shift
    do_link "$@"
    ;;
  unlink)
    shift
    do_unlink "$@"
    ;;
  rename)
    shift
    do_rename "$@"
    ;;
  manage)
    do_manage
    ;;
  current)
    shift
    do_current "$@"
    ;;
  -h|--help|"")
    show_help
    ;;
  *)
    error "Unknown command: $COMMAND"
    echo ""
    show_help
    exit 1
    ;;
esac
