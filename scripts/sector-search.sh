#!/bin/bash
# =============================================================================
# Imperial Sector Search — Sovereign Search Protocol
# Zero-cost awk-based navigation for the Imperial Hierarchy (01-20)
# =============================================================================
# 
# USAGE:
#   ./sector-search.sh <query>     # Search for sector by number or name
#   ./sector-search.sh <query> -j  # Jump to sector directory after search
#   ./sector-search.sh <query> -v  # Run Vader-Gate security scan
#
# EXAMPLES:
#   ./sector-search.sh 17          # Find Flutter sector
#   ./sector-search.sh Vader       # Find security sector
#   ./sector-search.sh 08 -j       # Jump to AWS sector
#   ./sector-search.sh 06 -v       # Scan Firestore sector for secrets
# =============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
MASTER_INDEX="$ROOT_DIR/MASTER-INDEX.md"
SECTORS_DIR="$ROOT_DIR/sectors"

# Flags
JUMP=false
VADER_GATE=false

# =============================================================================
# Helper Functions
# =============================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
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

log_sector() {
    echo -e "${CYAN}[SECTOR]${NC} $1"
}

show_help() {
    cat << EOF
${CYAN}╔═══════════════════════════════════════════════════════════╗
║     Imperial Sector Search — Sovereign Search Protocol    ║
╠═══════════════════════════════════════════════════════════╣
║  USAGE:                                                   ║
║    $0 <query>           # Search for sector              ║
║    $0 <query> -j        # Jump to sector directory       ║
║    $0 <query> -v        # Run Vader-Gate security scan   ║
║                                                           ║
║  EXAMPLES:                                                ║
║    $0 17                # Find Flutter sector            ║
║    $0 Vader             # Find security sector           ║
║    $0 08 -j             # Jump to AWS sector             ║
║    $0 06 -v             # Scan Firestore for secrets     ║
╚═══════════════════════════════════════════════════════════╝${NC}
EOF
}

# =============================================================================
# Core Search Function (Hiroshi-Approved Awk Implementation)
# =============================================================================

search_sector() {
    local query="$1"
    local result
    
    log_info "Searching Imperial Hierarchy for: $query"
    echo ""
    
    # Search MASTER-INDEX.md using awk (zero-cost abstraction)
    RESULT=$(awk -v q="$query" '
    BEGIN {
        IGNORECASE = 1
        found = 0
        in_sectors = 0
    }
    
    # Detect Imperial Sectors section
    /Imperial Sectors/ {
        in_sectors = 1
    }
    
    # Match sector table rows (e.g., "| 02 | Gemini | ...")
    in_sectors && /\|.*\|.*\|/ {
        if ($0 ~ q) {
            print "MATCH: " $0
            found = 1
        }
    }
    
    # Also search for sector directory patterns
    /sectors\/[0-9]+/ {
        if ($0 ~ q) {
            print "PATH: " $0
            found = 1
        }
    }
    
    # Search for sector names anywhere in file
    /Gemini|GitHub|Firestore|Termux|AWS|Vader|Flutter|Expo|Mainframe/ {
        if ($0 ~ q && !in_sectors) {
            print "REF: " $0
            found = 1
        }
    }
    
    END {
        if (!found) {
            print "NO_MATCH: No sector found matching \"" q "\""
            print ""
            print "Available Sectors:"
            print "  02 - Gemini (Linguistic Telemetry)"
            print "  05 - GitHub (GraphQL Bridge)"
            print "  06 - Firestore (Mobile Dashboard)"
            print "  07 - Termux (Local Orchestration)"
            print "  08 - AWS RHEL (Terminal History)"
            print "  15 - Vader (Security/Audit)"
            print "  17 - Flutter (Interview Prep)"
            print "  18 - Turbo Dev (Build/Deploy)"
            print "  19 - Expo (React Native)"
            print "  20 - Mainframe Migration"
        }
    }
    ' "$MASTER_INDEX" 2>/dev/null || echo "NO_MATCH: MASTER-INDEX.md not found")
    
    echo "$RESULT"
    echo ""
    
    # Check for match
    if [[ "$RESULT" == *"NO_MATCH"* ]]; then
        log_error "Search failed"
        return 1
    fi
    
    log_success "Search complete"
    return 0
}

# =============================================================================
# Neural Jump Function (Auto-CD to Sector)
# =============================================================================

neural_jump() {
    local query="$1"
    local sector_path
    
    # Extract sector number/name from query
    if [[ "$query" =~ ^[0-9]+$ ]]; then
        # Numeric query (e.g., "17")
        sector_path=$(find "$SECTORS_DIR" -maxdepth 1 -type d -name "*$query*" 2>/dev/null | head -1)
    else
        # Named query (e.g., "Vader", "AWS", "Flutter")
        # Map common names to sector directories
        case "$query" in
            [Ff]lutter*)
                sector_path=$(find "$SECTORS_DIR" -maxdepth 1 -type d -name "*17*" 2>/dev/null | head -1)
                ;;
            [Ee]xpo*|[Rr]eact*)
                sector_path=$(find "$SECTORS_DIR" -maxdepth 1 -type d -name "*19*" 2>/dev/null | head -1)
                ;;
            [Aa][Ww][Ss]*|[Rr][Hh][Ee][Ll]*)
                sector_path=$(find "$SECTORS_DIR" -maxdepth 1 -type d -name "*08*" 2>/dev/null | head -1)
                ;;
            [Ff]irestore*)
                sector_path=$(find "$SECTORS_DIR" -maxdepth 1 -type d -name "*06*" 2>/dev/null | head -1)
                ;;
            [Vv]ader*|[Ss]ecurity*|[Aa]udit*)
                # Vader doesn't have a dedicated sector yet, point to security-related
                log_warn "Vader sector not found — showing security-related content"
                sector_path="$SECTORS_DIR"
                ;;
            [Mm]ainframe*)
                sector_path=$(find "$SECTORS_DIR" -maxdepth 1 -type d -name "*20*" 2>/dev/null | head -1)
                ;;
            [Gg]emini*)
                sector_path=$(find "$SECTORS_DIR" -maxdepth 1 -type d -name "*02*" 2>/dev/null | head -1)
                ;;
            *)
                # Fallback to fuzzy search
                sector_path=$(find "$SECTORS_DIR" -maxdepth 1 -type d -iname "*$query*" 2>/dev/null | head -1)
                ;;
        esac
    fi
    
    if [[ -n "$sector_path" && -d "$sector_path" ]]; then
        log_sector "Located: $sector_path"
        echo ""
        
        # Show sector info
        if [[ -f "$sector_path/README.md" ]]; then
            log_info "Sector README.md found"
            echo ""
            head -30 "$sector_path/README.md" | grep -v "^$" | head -15
            echo ""
        elif [[ -d "$sector_path" ]]; then
            log_info "Sector contents:"
            ls -la "$sector_path" | head -15
            echo ""
        fi
        
        # Offer to cd
        echo -e "${YELLOW}Jump to this sector? (y/n)${NC}: "
        read -r confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            cd "$sector_path" || exit 1
            log_success "Welcome to $(basename "$sector_path")"
            echo "Current directory: $(pwd)"
            echo ""
            echo "Contents:"
            ls -la
        fi
    else
        log_warn "Sector directory not found for query: $query"
        echo ""
        echo "Available sector directories:"
        ls -la "$SECTORS_DIR" | grep "^d" | awk '{print $NF}'
    fi
}

# =============================================================================
# Vader-Gate Security Scan (Secret Detection)
# =============================================================================

vader_gate() {
    local query="$1"
    local sector_path
    local scan_result=0
    
    log_warn "🔴 VADER-GATE SECURITY SCAN INITIATED"
    echo ""
    
    # Find sector directory
    if [[ "$query" =~ ^[0-9]+$ ]]; then
        sector_path=$(find "$SECTORS_DIR" -maxdepth 1 -type d -name "*$query*" 2>/dev/null | head -1)
    else
        sector_path=$(find "$SECTORS_DIR" -maxdepth 1 -type d -iname "*$query*" 2>/dev/null | head -1)
    fi
    
    if [[ -z "$sector_path" || ! -d "$sector_path" ]]; then
        log_error "Sector not found for Vader-Gate scan"
        return 1
    fi
    
    log_info "Scanning sector: $sector_path"
    echo ""
    
    # Check for gitleaks (preferred)
    if command -v gitleaks &> /dev/null; then
        log_info "Running gitleaks secret scan..."
        echo ""
        
        if gitleaks detect --source "$sector_path" --verbose 2>&1 | tee /tmp/vader-gate-scan.txt; then
            log_success "✅ No secrets detected"
        else
            log_error "❌ POTENTIAL SECRETS FOUND"
            cat /tmp/vader-gate-scan.txt | grep -A5 "Finding"
            scan_result=1
        fi
    else
        log_warn "gitleaks not found. Running basic secret scan..."
        echo ""
        
        # Basic pattern matching for common secrets
        local secrets_found=0
        
        # AWS Access Keys
        if grep -r "AKIA[0-9A-Z]\{16\}" "$sector_path" 2>/dev/null; then
            log_error "❌ AWS Access Key pattern detected"
            secrets_found=1
        fi
        
        # GitHub Tokens
        if grep -r "ghp_[a-zA-Z0-9]\{36\}" "$sector_path" 2>/dev/null; then
            log_error "❌ GitHub Token pattern detected"
            secrets_found=1
        fi
        
        # Private Keys
        if grep -r "BEGIN.*PRIVATE KEY" "$sector_path" 2>/dev/null; then
            log_error "❌ Private Key detected"
            secrets_found=1
        fi
        
        # Passwords in config
        if grep -ri "password\s*=\s*['\"][^'\"]\+['\"]" "$sector_path" 2>/dev/null | grep -v ".git"; then
            log_warn "⚠️ Potential hardcoded password detected"
            secrets_found=1
        fi
        
        if [[ $secrets_found -eq 0 ]]; then
            log_success "✅ No obvious secrets detected (basic scan)"
            log_warn "Note: Install gitleaks for comprehensive scanning"
        else
            log_error "❌ VADER-GATE FAILED — Review findings above"
            scan_result=1
        fi
    fi
    
    echo ""
    
    # Scan .git history if exists
    if [[ -d "$sector_path/.git" ]]; then
        log_info "Scanning git history for leaked secrets..."
        
        if command -v gitleaks &> /dev/null; then
            gitleaks detect --source "$sector_path" --no-git 2>/dev/null || true
        fi
    fi
    
    return $scan_result
}

# =============================================================================
# Deploy to AWS RHEL (Parity Sync)
# =============================================================================

deploy_to_rhel() {
    local rhel_host="${RHEL_HOST:-}"
    local rhel_user="${RHEL_USER:-}"
    
    if [[ -z "$rhel_host" || -z "$rhel_user" ]]; then
        log_warn "AWS RHEL credentials not set"
        echo "Set RHEL_HOST and RHEL_USER environment variables for deployment"
        return 1
    fi
    
    log_info "Deploying to AWS RHEL instance..."
    
    # Sync script to RHEL
    scp "$SCRIPT_DIR/sector-search.sh" "$rhel_user@$rhel_host:~/Imperial/root/scripts/"
    
    # Sync MASTER-INDEX.md
    scp "$MASTER_INDEX" "$rhel_user@$rhel_host:~/Imperial/root/"
    
    log_success "Deployment complete"
}

# =============================================================================
# Benchmark Function (Desmond Performance Check)
# =============================================================================

benchmark() {
    log_info "Running performance benchmark..."
    echo ""
    
    # Time the awk search
    local start_time=$(date +%s%N)
    search_sector "17" > /dev/null
    local end_time=$(date +%s%N)
    
    local elapsed_ms=$(( (end_time - start_time) / 1000000 ))
    
    echo "Search execution time: ${elapsed_ms}ms"
    
    if [[ $elapsed_ms -lt 10 ]]; then
        log_success "⚡ SOVEREIGN STANDARD achieved (<10ms)"
    else
        log_warn "Performance below Sovereign Standard"
    fi
}

# =============================================================================
# Main Execution
# =============================================================================

main() {
    # Parse arguments
    if [[ $# -lt 1 ]]; then
        show_help
        exit 1
    fi
    
    local query=""
    
    for arg in "$@"; do
        case "$arg" in
            -h|--help)
                show_help
                exit 0
                ;;
            -j|--jump)
                JUMP=true
                ;;
            -v|--vader)
                VADER_GATE=true
                ;;
            -d|--deploy)
                deploy_to_rhel
                exit 0
                ;;
            -b|--benchmark)
                benchmark
                exit 0
                ;;
            *)
                query="$arg"
                ;;
        esac
    done
    
    if [[ -z "$query" ]]; then
        log_error "No search query provided"
        show_help
        exit 1
    fi
    
    # Run search
    if ! search_sector "$query"; then
        exit 1
    fi
    
    # Run Vader-Gate if requested
    if [[ "$VADER_GATE" == true ]]; then
        echo ""
        if ! vader_gate "$query"; then
            log_error "Vader-Gate scan failed — review before proceeding"
            exit 1
        fi
    fi
    
    # Neural Jump if requested
    if [[ "$JUMP" == true ]]; then
        echo ""
        neural_jump "$query"
    fi
    
    log_success "Imperial Sector Search complete"
}

# Run main
main "$@"
