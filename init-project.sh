#!/usr/bin/env bash
#
# Blueprint Project Initializer
# Initializes Blueprint data for the current project in ~/.claude/blueprint/{project}/
#
# Usage:
#   ./init-project.sh [--force]
#
# Run this from your project directory, or set CLAUDE_PROJECT_DIR.
#

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Script directory (where init-project.sh lives)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_DIR="${SCRIPT_DIR}/core"

# Flags
FORCE=false

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------

print_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Initializes Blueprint data for the current project.

Options:
  --force      Reinitialize even if already initialized (overwrites existing)
  -h, --help   Show this help message

The project is identified by \$CLAUDE_PROJECT_DIR or current directory.
Data is stored in ~/.claude/blueprint/{project-path}/
EOF
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Convert absolute path to directory name
# Example: /Users/me/projects/blueprint → Users-me-projects-blueprint
path_to_dirname() {
    local path="$1"
    path="${path#/}"        # Remove leading /
    path="${path// /-}"     # Replace spaces with -
    echo "${path//\//-}"    # Replace / with -
}

# Get blueprint data directory for a project
get_blueprint_data_dir() {
    local project_path="$1"
    local dirname
    dirname=$(path_to_dirname "$project_path")
    echo "$HOME/.claude/blueprint/$dirname"
}

# Copy directory
copy_directory() {
    local src="$1"
    local dest="$2"
    local name="$3"

    if [[ ! -d "$src" ]]; then
        log_warn "Source not found: $src"
        return 0
    fi

    mkdir -p "$dest"
    rsync -a "$src/" "$dest/"
    echo "  $name/ [created]"
}

# Validate source directories exist
validate_source() {
    if [[ ! -d "$CORE_DIR" ]]; then
        log_error "Core directory not found: $CORE_DIR"
        log_error "Please run this script from the Blueprint framework root."
        exit 1
    fi
}

# Check if global installation exists
check_global_install() {
    if [[ ! -d "$HOME/.claude/skills/blueprint" ]]; then
        log_error "Blueprint not installed globally."
        log_error "Run './install-global.sh' first."
        exit 1
    fi
}

# Main initialization
init_project() {
    local project_path="${CLAUDE_PROJECT_DIR:-$(pwd)}"
    local target_dir
    target_dir=$(get_blueprint_data_dir "$project_path")

    echo ""
    log_info "Blueprint Project Initializer"
    log_info "=============================="
    log_info "Project: $project_path"
    log_info "Target:  $target_dir"
    echo ""

    # Check if already initialized
    if [[ -d "$target_dir" ]] && [[ "$FORCE" != "true" ]]; then
        log_error "Project already initialized at: $target_dir"
        log_info "Use --force to reinitialize (will overwrite existing files)"
        exit 1
    fi

    if [[ -d "$target_dir" ]] && [[ "$FORCE" == "true" ]]; then
        log_warn "Reinitializing (--force specified)"
    fi

    # Create target directory
    mkdir -p "$target_dir"

    # Copy framework directories
    copy_directory "$CORE_DIR/constitutions" "$target_dir/constitutions" "constitutions"
    copy_directory "$CORE_DIR/forms" "$target_dir/forms" "forms"
    copy_directory "$CORE_DIR/front-matters" "$target_dir/front-matters" "front-matters"
    copy_directory "$CORE_DIR/gates" "$target_dir/gates" "gates"
    copy_directory "$CORE_DIR/templates" "$target_dir/templates" "templates"

    # Create empty plans directory
    mkdir -p "$target_dir/plans"
    echo "  plans/ [created]"

    echo ""
    log_success "Project initialized!"
    log_info "Blueprint data stored at: $target_dir"
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --force)
                FORCE=true
                shift
                ;;
            -h|--help)
                print_usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
    done

    validate_source
    check_global_install
    init_project
}

main "$@"
