# =============================================================================
# Imperial Purge Script
# Nukes infrastructure and redeploys from scratch
# USE WITH EXTREME CAUTION - ESPECIALLY IN PRODUCTION
# =============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
ENVIRONMENT="${1:-staging}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INFRA_DIR="${SCRIPT_DIR}/sectors/08-aws/infrastructure"

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

confirm() {
    read -p "$1 (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_error "Operation cancelled by user"
        exit 1
    fi
}

# Validate environment
if [[ "$ENVIRONMENT" != "staging" && "$ENVIRONMENT" != "production" ]]; then
    log_error "Invalid environment: $ENVIRONMENT (must be 'staging' or 'production')"
    exit 1
fi

# Production safety check
if [[ "$ENVIRONMENT" == "production" ]]; then
    log_error "=========================================="
    log_error "  PRODUCTION ENVIRONMENT SELECTED"
    log_error "=========================================="
    confirm "Are you ABSOLUTELY SURE you want to nuke production? This will cause downtime."
    confirm "This is your LAST CHANCE. Continue with production destruction?"
fi

log_info "Starting Imperial Purge for environment: $ENVIRONMENT"
log_info "Infrastructure directory: $INFRA_DIR"

# Change to infrastructure directory
cd "$INFRA_DIR"

# Initialize Terraform
log_info "Initializing Terraform..."
terraform init -reconfigure

# Select correct tfvars file
TFVARS_FILE="terraform.tfvars"
if [[ "$ENVIRONMENT" == "production" ]]; then
    TFVARS_FILE="terraform.tfvars.production"
fi

log_info "Using variables file: $TFVARS_FILE"

# Show what will be destroyed
log_info "Planning destruction..."
terraform plan -destroy -var-file="$TFVARS_FILE" -out=tfplan

# Confirm destruction
if [[ "$ENVIRONMENT" == "staging" ]]; then
    confirm "Ready to destroy $ENVIRONMENT infrastructure. Continue?"
fi

# Execute destruction
log_warn "Destroying infrastructure..."
terraform apply tfplan

# Remove state file reference (optional - comment out to keep state)
# log_warn "Removing local state file..."
# rm -f terraform.tfstate

log_info "=========================================="
log_info "  IMPERIAL PURGE COMPLETE"
log_info "=========================================="
log_info "Infrastructure for $ENVIRONMENT has been nuked."
log_info ""
log_info "To redeploy, run:"
log_info "  ./sectors/08-aws/imperial-arsenal.sh $ENVIRONMENT"
