#!/bin/bash
# =============================================================================
# Imperial Environment Initialization Script
# "The Root is Strong. The Empire Scales to Infinity."
# =============================================================================
#
# USAGE: bash ./scripts/init-env.sh
#
# This script:
# 1. Creates sector directory structure
# 2. Installs dependencies (npm, pip, rust)
# 3. Configures environment variables
# 4. Sets up CLI tool symlinks
# 5. Verifies installation
# =============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SECTORS_DIR="$ROOT_DIR/sectors"

# =============================================================================
# Helper Functions
# =============================================================================

log_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_command() {
    if ! command -v "$1" &> /dev/null; then
        log_error "$1 is not installed"
        return 1
    fi
    return 0
}

# =============================================================================
# Prerequisites Check
# =============================================================================

check_prerequisites() {
    log_info "Checking prerequisites..."
    
    local missing=0
    
    # Check for Git
    if ! check_command git; then
        log_error "Git is required. Install with: apt install git"
        missing=1
    fi
    
    # Check for Node.js (optional but recommended)
    if ! check_command node; then
        log_warn "Node.js not found. Some features will be unavailable."
    fi
    
    # Check for Python 3
    if ! check_command python3; then
        log_warn "Python 3 not found. Some features will be unavailable."
    fi
    
    # Check for Rust (optional)
    if ! check_command cargo; then
        log_warn "Rust not found. Some features will be unavailable."
    fi
    
    if [[ $missing -eq 1 ]]; then
        log_error "Missing critical dependencies. Please install and re-run."
        exit 1
    fi
    
    log_success "Prerequisites check complete"
}

# =============================================================================
# Create Directory Structure
# =============================================================================

create_directories() {
    log_info "Creating directory structure..."
    
    # Core directories
    mkdir -p "$ROOT_DIR"/{docs,src/python,src/typescript,src/rust}
    mkdir -p "$ROOT_DIR"/scripts
    mkdir -p "$ROOT_DIR"/termux/{bin,configs}
    
    # Sector subdirectories (if not exists)
    for sector_dir in "$SECTORS_DIR"/*/; do
        if [[ -d "$sector_dir" ]]; then
            mkdir -p "$sector_dir"/{lib,tests,docs} 2>/dev/null || true
        fi
    done
    
    log_success "Directory structure created"
}

# =============================================================================
# Install Dependencies
# =============================================================================

install_dependencies() {
    log_info "Installing dependencies..."
    
    # Install Node.js dependencies (if package.json exists)
    if [[ -f "$ROOT_DIR/package.json" ]]; then
        log_info "Installing Node.js dependencies..."
        cd "$ROOT_DIR"
        npm install --workspaces --include=dev || log_warn "npm install failed"
    fi
    
    # Install Python dependencies (if requirements.txt exists)
    if [[ -f "$ROOT_DIR/requirements.txt" ]]; then
        log_info "Installing Python dependencies..."
        pip3 install -r "$ROOT_DIR/requirements.txt" || log_warn "pip install failed"
    fi
    
    # Install Rust dependencies (if Cargo.toml exists)
    if [[ -f "$ROOT_DIR/Cargo.toml" ]]; then
        log_info "Installing Rust dependencies..."
        cd "$ROOT_DIR"
        cargo build || log_warn "cargo build failed"
    fi
    
    log_success "Dependencies installed"
}

# =============================================================================
# Setup CLI Symlinks
# =============================================================================

setup_cli_symlinks() {
    log_info "Setting up CLI symlinks..."
    
    local bin_dir="$ROOT_DIR/termux/bin"
    mkdir -p "$bin_dir"
    
    # Create symlinks for available CLI tools
    local cli_tools=(
        "sectors/25-leo-cli/src/leo.js:leo"
        "sectors/26-hospital-api/src/med.js:med"
        "sectors/09-security/bug-bounty.py:bug-bounty"
        "sectors/09-security/bug-bounty--echo.sh:alert"
        "sectors/08-aws/aws-yolo.sh:yolo"
    )
    
    for tool_mapping in "${cli_tools[@]}"; do
        IFS=':' read -r tool_path tool_name <<< "$tool_mapping"
        
        if [[ -f "$ROOT_DIR/$tool_path" ]]; then
            ln -sf "$ROOT_DIR/$tool_path" "$bin_dir/$tool_name" 2>/dev/null || true
            log_info "Created symlink: $tool_name"
        fi
    done
    
    log_success "CLI symlinks created"
}

# =============================================================================
# Configure Environment
# =============================================================================

configure_environment() {
    log_info "Configuring environment..."
    
    # Create .env file if not exists
    local env_file="$ROOT_DIR/.env"
    
    if [[ ! -f "$env_file" ]]; then
        cat > "$env_file" << 'EOF'
# Imperial Environment Configuration
# Copy this file to .env and fill in your values

# AWS Configuration
AWS_REGION=us-east-1
AWS_PROFILE=imperial

# GitHub Configuration
GITHUB_TOKEN=

# Firebase Configuration
FIREBASE_PROJECT_ID=
FIREBASE_API_KEY=

# Slack Webhook (for alerts)
SLACK_WEBHOOK_URL=

# Discord Webhook (for alerts)
DISCORD_WEBHOOK_URL=

# Telegram Bot (for alerts)
TELEGRAM_BOT_TOKEN=
TELEGRAM_CHAT_ID=
EOF
        log_info "Created .env template. Please fill in your credentials."
    else
        log_info ".env file already exists"
    fi
    
    # Add to .bashrc/.zshrc (Termux-friendly)
    local shell_rc=""
    if [[ -f "$HOME/.bashrc" ]]; then
        shell_rc="$HOME/.bashrc"
    elif [[ -f "$HOME/.zshrc" ]]; then
        shell_rc="$HOME/.zshrc"
    fi
    
    if [[ -n "$shell_rc" ]]; then
        # Check if already added
        if ! grep -q "ROOT_DIR" "$shell_rc" 2>/dev/null; then
            cat >> "$shell_rc" << EOF

# Imperial Root Configuration
export ROOT_DIR="$ROOT_DIR"
export PATH="\$PATH:\$ROOT_DIR/termux/bin"
alias leo='node \$ROOT_DIR/sectors/25-leo-cli/src/leo.js'
alias med='node \$ROOT_DIR/sectors/26-hospital-api/src/med.js'
EOF
            log_info "Added configuration to $shell_rc"
        fi
    fi
    
    log_success "Environment configured"
}

# =============================================================================
# Verify Installation
# =============================================================================

verify_installation() {
    log_info "Verifying installation..."
    
    local errors=0
    
    # Check directory structure
    if [[ ! -d "$SECTORS_DIR" ]]; then
        log_error "Sectors directory not found"
        ((errors++))
    fi
    
    # Check CLI tools
    if [[ ! -f "$ROOT_DIR/sectors/25-leo-cli/src/leo.js" ]]; then
        log_warn "LEO CLI not found"
    fi
    
    if [[ ! -f "$ROOT_DIR/sectors/26-hospital-api/src/med.js" ]]; then
        log_warn "MED CLI not found"
    fi
    
    # Check security tools
    if [[ ! -f "$ROOT_DIR/sectors/09-security/bug-bounty.py" ]]; then
        log_warn "Bug bounty scanner not found"
    fi
    
    if [[ $errors -eq 0 ]]; then
        log_success "Installation verified successfully"
    else
        log_error "Installation completed with $errors errors"
    fi
    
    return $errors
}

# =============================================================================
# Display Welcome Message
# =============================================================================

display_welcome() {
    cat << 'EOF'

╔═══════════════════════════════════════════════════════════╗
║     Imperial Environment Initialized                      ║
╠═══════════════════════════════════════════════════════════╣
║  The Root is Strong. The Empire Scales to Infinity.       ║
║                                                           ║
║  Quick Start:                                             ║
║    leo --version         # Law Enforcement CLI            ║
║    med --version         # Hospital CLI                   ║
║    bug-bounty --help     # Security Scanner               ║
║    yolo --help           # AWS Deployment                 ║
║                                                           ║
║  Next Steps:                                              ║
║    1. Fill in .env with your credentials                 ║
║    2. Run: source ~/.bashrc (or ~/.zshrc)                ║
║    3. Explore: ./scripts/sector-search.sh 17             ║
╚═══════════════════════════════════════════════════════════╝

EOF
}

# =============================================================================
# Main Execution
# =============================================================================

main() {
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║     Imperial Environment Initialization                   ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    check_prerequisites
    create_directories
    install_dependencies
    setup_cli_symlinks
    configure_environment
    verify_installation
    display_welcome
    
    log_success "Initialization complete!"
}

# Run main
main "$@"
