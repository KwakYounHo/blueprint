#!/usr/bin/env bash
#
# Blueprint Framework Installer
# Copies core framework files to target project directory.
#
# Usage:
#   ./install.sh <target-dir>
#   ./install.sh --dry-run <target-dir>
#
# Behavior:
#   - core/claude/*     → <target-dir>/.claude/
#   - core/* (others)   → <target-dir>/blueprint/
#   - Existing files with different names are preserved
#   - Existing files with same names are overwritten
#

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Script directory (where install.sh lives)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_DIR="${SCRIPT_DIR}/core"

# Flags
DRY_RUN=false

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------

print_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] <target-dir>

Options:
  --dry-run    Show what would be copied without actually copying
  -h, --help   Show this help message

Arguments:
  target-dir   Destination directory for framework installation

Examples:
  $(basename "$0") /path/to/my-project
  $(basename "$0") --dry-run /path/to/my-project
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

log_dry() {
    echo -e "${YELLOW}[DRY-RUN]${NC} $1"
}

# Copy directory using rsync
# Preserves existing files with different names, overwrites same-named files
# Args:
#   $1 - Source directory
#   $2 - Destination directory
copy_directory() {
    local src="$1"
    local dest="$2"

    if [[ ! -d "$src" ]]; then
        log_warn "Source directory not found: $src"
        return 0
    fi

    # Create destination if it doesn't exist
    if [[ "$DRY_RUN" == "true" ]]; then
        if [[ ! -d "$dest" ]]; then
            log_dry "Would create directory: $dest"
        fi
    else
        mkdir -p "$dest"
    fi

    # Use rsync for intelligent copying
    # -a: archive mode (preserves permissions, timestamps, etc.)
    # -v: verbose
    # --ignore-existing is NOT used - we want to overwrite same-named files
    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry "Would copy: $src/ → $dest/"
        rsync -av --dry-run "$src/" "$dest/" 2>/dev/null | grep -E "^[^.]" | while read -r line; do
            [[ -n "$line" ]] && log_dry "  $line"
        done
    else
        log_info "Copying: $src/ → $dest/"
        rsync -av "$src/" "$dest/" | grep -E "^[^.]" | while read -r line; do
            [[ -n "$line" ]] && echo "  $line"
        done
    fi
}

# Validate that core directory exists and has expected structure
validate_core_dir() {
    if [[ ! -d "$CORE_DIR" ]]; then
        log_error "Core directory not found: $CORE_DIR"
        log_error "Please run this script from the Blueprint framework root."
        exit 1
    fi

    if [[ ! -d "$CORE_DIR/claude" ]]; then
        log_error "core/claude directory not found"
        exit 1
    fi
}

# Validate target directory
validate_target_dir() {
    local target="$1"

    # Check if target exists
    if [[ ! -d "$target" ]]; then
        log_error "Target directory does not exist: $target"
        log_error "Please create the directory first or provide a valid path."
        exit 1
    fi

    # Check if target is writable
    if [[ ! -w "$target" ]]; then
        log_error "Target directory is not writable: $target"
        exit 1
    fi
}

# Main installation logic
install_framework() {
    local target_dir="$1"

    log_info "Blueprint Framework Installer"
    log_info "=============================="
    log_info "Source: $CORE_DIR"
    log_info "Target: $target_dir"
    [[ "$DRY_RUN" == "true" ]] && log_warn "DRY-RUN MODE - No files will be copied"
    echo ""

    # Step 1: Copy core/claude → target/.claude
    log_info "Step 1/2: Installing Claude Code configuration..."
    copy_directory "$CORE_DIR/claude" "$target_dir/.claude"
    echo ""

    # Step 2: Copy other core directories → target/blueprint
    log_info "Step 2/2: Installing Blueprint framework files..."

    local blueprint_dirs=("gates" "front-matters" "forms" "constitutions" "templates")

    for dir in "${blueprint_dirs[@]}"; do
        if [[ -d "$CORE_DIR/$dir" ]]; then
            copy_directory "$CORE_DIR/$dir" "$target_dir/blueprint/$dir"
        fi
    done

    echo ""
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warn "DRY-RUN complete. No files were copied."
        log_info "Run without --dry-run to perform actual installation."
    else
        log_success "Installation complete!"
        log_info "Installed to: $target_dir"
    fi
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    local target_dir=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            -h|--help)
                print_usage
                exit 0
                ;;
            -*)
                log_error "Unknown option: $1"
                print_usage
                exit 1
                ;;
            *)
                if [[ -z "$target_dir" ]]; then
                    target_dir="$1"
                else
                    log_error "Multiple target directories specified"
                    print_usage
                    exit 1
                fi
                shift
                ;;
        esac
    done

    # Check required argument
    if [[ -z "$target_dir" ]]; then
        log_error "Target directory is required"
        echo ""
        print_usage
        exit 1
    fi

    # Convert to absolute path
    target_dir="$(cd "$target_dir" 2>/dev/null && pwd)" || {
        log_error "Invalid target directory: $target_dir"
        exit 1
    }

    # Validations
    validate_core_dir
    validate_target_dir "$target_dir"

    # Run installation
    install_framework "$target_dir"
}

main "$@"
