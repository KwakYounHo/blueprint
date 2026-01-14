#!/usr/bin/env bash
#
# Blueprint Global Installer
# Installs Claude Code configuration (agents, skills, commands) to ~/.claude/
#
# Usage:
#   ./install-global.sh [--dry-run]
#
# This is a ONE-TIME installation for the user.
# For per-project setup, run 'blueprint project init <alias>' in your project.
#

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Script directory (where install-global.sh lives)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_DIR="${SCRIPT_DIR}/core"
CORE_CLAUDE_DIR="${CORE_DIR}/claude"
TARGET_DIR="$HOME/.claude"
BLUEPRINT_DIR="$HOME/.claude/blueprint"
BLUEPRINT_BASE_DIR="$BLUEPRINT_DIR/base"

# Flags
DRY_RUN=false

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------

print_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Installs Blueprint Claude Code configuration to ~/.claude/

Options:
  --dry-run    Show what would be copied without actually copying
  -h, --help   Show this help message

After running this, use 'blueprint project init <alias>' in each project.
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
copy_directory() {
    local src="$1"
    local dest="$2"
    local name="$3"

    if [[ ! -d "$src" ]]; then
        log_warn "Source directory not found: $src"
        return 0
    fi

    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry "Would copy: $name/ → $dest/"
    else
        mkdir -p "$dest"
        rsync -a "$src/" "$dest/"
        log_success "$name/ → $dest/"
    fi
}

# Validate source directory
validate_source() {
    if [[ ! -d "$CORE_CLAUDE_DIR" ]]; then
        log_error "Core claude directory not found: $CORE_CLAUDE_DIR"
        log_error "Please run this script from the Blueprint framework root."
        exit 1
    fi
}

# Main installation
install_global() {
    echo ""
    log_info "Blueprint Global Installer"
    log_info "==========================="
    log_info "Source: $CORE_CLAUDE_DIR"
    log_info "Target: $TARGET_DIR"
    [[ "$DRY_RUN" == "true" ]] && log_warn "DRY-RUN MODE - No files will be copied"
    echo ""

    # Copy Claude Code configuration
    log_info "Step 1/2: Installing Claude Code configuration..."
    copy_directory "$CORE_CLAUDE_DIR/agents" "$TARGET_DIR/agents" "agents"
    copy_directory "$CORE_CLAUDE_DIR/skills" "$TARGET_DIR/skills" "skills"
    copy_directory "$CORE_CLAUDE_DIR/commands" "$TARGET_DIR/commands" "commands"

    echo ""

    # Copy Blueprint base files
    log_info "Step 2/2: Installing Blueprint base files..."
    copy_directory "$CORE_DIR/constitutions" "$BLUEPRINT_BASE_DIR/constitutions" "base/constitutions"
    copy_directory "$CORE_DIR/forms" "$BLUEPRINT_BASE_DIR/forms" "base/forms"
    copy_directory "$CORE_DIR/front-matters" "$BLUEPRINT_BASE_DIR/front-matters" "base/front-matters"
    copy_directory "$CORE_DIR/gates" "$BLUEPRINT_BASE_DIR/gates" "base/gates"
    copy_directory "$CORE_DIR/templates" "$BLUEPRINT_BASE_DIR/templates" "base/templates"

    # Create projects directory
    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry "Would create: $BLUEPRINT_DIR/projects/"
    else
        mkdir -p "$BLUEPRINT_DIR/projects"
        log_success "projects/ directory created"
    fi

    echo ""
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warn "DRY-RUN complete. No files were copied."
        log_info "Run without --dry-run to perform actual installation."
    else
        log_success "Global installation complete!"
        echo ""
        log_info "Next steps:"
        log_info "  1. cd /path/to/your/project"
        log_info "  2. blueprint project init <alias>"
    fi
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
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
            *)
                log_error "Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
    done

    validate_source
    install_global
}

main "$@"
