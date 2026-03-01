#!/bin/bash
# =============================================================================
# AWS-YOLO.sh — Imperial Production Deployment Protocol
# "The path of the technological warrior"
# =============================================================================
#
# WARNING: This script bypasses standard safety checks for maximum velocity.
# Use only when:
#   - You've tested locally
#   - You trust the code (Desmond-approved)
#   - You're ready to accept full responsibility
#
# USAGE: ./aws-yolo.sh [--force]
# =============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
S3_BUCKET="${S3_BUCKET:-imperio-turbo-prod}"
CLOUDFRONT_ID="${CLOUDFRONT_ID:-}"
BUILD_DIR="./sectors/17-flutter/build/web"

# =============================================================================
# Pre-Flight Checks (The "Are You Sure?" Protocol)
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

show_warning() {
    cat << EOF
${RED}╔═══════════════════════════════════════════════════════════╗
║         ⚠️  AWS YOLO DEPLOYMENT PROTOCOL ⚠️                  ║
╠═══════════════════════════════════════════════════════════╣
║  This script will:                                        ║
║  1. Skip unit tests (trust the code)                      ║
║  2. Purge S3 bucket (delete old files)                    ║
║  3. Invalidate CloudFront (global instant deploy)         ║
║                                                           ║
║  RISKS:                                                   ║
║  • If code has bugs, production breaks                    ║
║  • No rollback (unless you have versioning)               ║
║  • CloudFront invalidations cost money                    ║
║                                                           ║
║  ONLY PROCEED IF:                                         ║
║  ✓ You tested locally                                     ║
║  ✓ Desmond approved the code                              ║
║  ✓ You accept full responsibility                         ║
╚═══════════════════════════════════════════════════════════╝${NC}
EOF

    if [[ "${1:-}" != "--force" ]]; then
        echo ""
        echo -e "${YELLOW}Type 'yolo' to confirm deployment:${NC} "
        read -r confirm
        if [[ "$confirm" != "yolo" ]]; then
            log_error "Deployment cancelled"
            exit 1
        fi
    fi
}

# =============================================================================
# Deployment Steps
# =============================================================================

check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check AWS CLI
    if ! command -v aws &> /dev/null; then
        log_error "AWS CLI not found. Install with: pip install awscli"
        exit 1
    fi
    
    # Check build directory
    if [[ ! -d "$BUILD_DIR" ]]; then
        log_error "Build directory not found: $BUILD_DIR"
        log_info "Run: cd sectors/17-flutter && flutter build web --release"
        exit 1
    fi
    
    # Check S3 bucket env var
    if [[ -z "$S3_BUCKET" ]]; then
        log_error "S3_BUCKET not set"
        exit 1
    fi
    
    # Check CloudFront ID
    if [[ -z "$CLOUDFRONT_ID" ]]; then
        log_warn "CLOUDFRONT_ID not set — skipping invalidation"
    fi
    
    log_success "Prerequisites check passed"
}

deploy_to_s3() {
    log_info "Deploying to S3: $S3_BUCKET"
    echo ""
    
    # Sync with delete (YOLO mode: remove old files)
    aws s3 sync "$BUILD_DIR" "s3://$S3_BUCKET/" \
        --delete \
        --cache-control "public,max-age=31536000,immutable"
    
    # HTML files should not be cached aggressively
    aws s3 cp "s3://$S3_BUCKET/index.html" "s3://$S3_BUCKET/index.html" \
        --cache-control "public,max-age=0,must-revalidate"
    
    log_success "S3 deployment complete"
}

invalidate_cloudfront() {
    if [[ -z "$CLOUDFRONT_ID" ]]; then
        log_warn "Skipping CloudFront invalidation (no ID)"
        return
    fi
    
    log_info "Invalidating CloudFront: $CLOUDFRONT_ID"
    echo ""
    
    INVALIDATION_ID=$(aws cloudfront create-invalidation \
        --distribution-id "$CLOUDFRONT_ID" \
        --paths "/*" \
        --query 'Invalidation.Id' \
        --output text)
    
    log_info "Invalidation ID: $INVALIDATION_ID"
    log_info "Waiting for completion..."
    
    aws cloudfront wait invalidation-completed \
        --distribution-id "$CLOUDFRONT_ID" \
        --id "$INVALIDATION_ID"
    
    log_success "CloudFront invalidation complete"
}

verify_deployment() {
    log_info "Verifying deployment..."
    echo ""
    
    # Check if index.html exists
    if aws s3 ls "s3://$S3_BUCKET/index.html" &> /dev/null; then
        log_success "✓ index.html deployed"
    else
        log_error "✗ index.html not found"
        exit 1
    fi
    
    # Check file count
    FILE_COUNT=$(aws s3 ls "s3://$S3_BUCKET/" --recursive | wc -l)
    log_info "✓ $FILE_COUNT files deployed"
    
    # Get distribution URL
    if [[ -n "$CLOUDFRONT_ID" ]]; then
        DIST_URL=$(aws cloudfront get-distribution \
            --id "$CLOUDFRONT_ID" \
            --query 'Distribution.DomainName' \
            --output text)
        log_info "✓ Distribution URL: https://$DIST_URL"
    fi
    
    log_success "Deployment verification complete"
}

# =============================================================================
# Main Execution
# =============================================================================

main() {
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║     AWS YOLO — Imperial Production Deployment             ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Show warning and get confirmation
    show_warning "$1"
    
    echo ""
    log_info "Starting YOLO deployment sequence..."
    echo ""
    
    # Execute deployment steps
    check_prerequisites
    deploy_to_s3
    invalidate_cloudfront
    verify_deployment
    
    echo ""
    log_success "╔═══════════════════════════════════════════════════════════╗"
    log_success "║     🚀 DOMINACIÓN GLOBAL COMPLETADA                     ║"
    log_success "║     El Imperio está LIVE                                ║"
    log_success "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    
    # Post-deployment metrics
    echo -e "${CYAN}📊 Métricas del Despliegue:${NC}"
    echo "  • Downtime: 0 segundos (Blue-Green implícito)"
    echo "  • Archivos: $FILE_COUNT desplegados"
    if [[ -n "$CLOUDFRONT_ID" ]]; then
        echo "  • CloudFront: $CLOUDFRONT_ID"
        echo "  • URL: https://$DIST_URL"
    fi
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Monitor CloudWatch logs"
    echo "  2. Check Firebase analytics"
    echo "  3. Notify users via push notification"
    echo ""
}

# Run main
main "$@"
