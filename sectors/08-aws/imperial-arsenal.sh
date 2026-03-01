#!/bin/bash
# =============================================================================
# Imperial Arsenal - Infrastructure Deployment Script
# Deploys Terraform infrastructure for Turbo Fleet
# =============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Configuration
ENVIRONMENT="${1:-staging}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INFRA_DIR="${SCRIPT_DIR}/infrastructure"

log_step "Imperial Arsenal - Infrastructure Deployment"
log_step "============================================"
log_info "Environment: $ENVIRONMENT"
log_info "Infrastructure: $INFRA_DIR"

cd "$INFRA_DIR"

# Select tfvars file
TFVARS_FILE="terraform.tfvars"
if [[ "$ENVIRONMENT" == "production" ]]; then
    TFVARS_FILE="terraform.tfvars.production"
fi

if [[ ! -f "$TFVARS_FILE" ]]; then
    log_error "Variables file not found: $TFVARS_FILE"
    exit 1
fi

# Initialize
log_step "Initializing Terraform..."
terraform init

# Format check
log_step "Checking Terraform format..."
terraform fmt -check -recursive || {
    log_warn "Terraform files need formatting. Running fmt..."
    terraform fmt -recursive
}

# Validate
log_step "Validating Terraform configuration..."
terraform validate

# Plan
log_step "Creating execution plan..."
terraform plan -var-file="$TFVARS_FILE" -out=tfplan

# Apply
log_warn "Ready to apply infrastructure changes"
read -p "Continue? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_step "Applying infrastructure changes..."
    terraform apply tfplan

    # Output important values
    log_step "============================================"
    log_step "Deployment Complete!"
    log_step "============================================"
    terraform output -no-color
else
    log_info "Deployment cancelled"
    exit 0
fi
