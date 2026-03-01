#!/bin/bash
# =============================================================================
# bug-bounty--echo.sh — Imperial Security Alert System (Sector 09)
# "El Pregonero" — The Town Crier
# =============================================================================
#
# Takes bug-bounty.py results and broadcasts alerts to command channels
# Slack, Discord, Telegram — the Imperio speaks when danger strikes
#
# USAGE: ./bug-bounty--echo.sh [--scan] [--slack] [--discord] [--telegram] [--all]
# =============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Configuration
SECTORS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SECTORS_DIR")"
REPORT_FILE="$SECTORS_DIR/last_scan.json"
LOG_FILE="$SECTORS_DIR/alerts.log"

# Webhook URLs (set via environment)
SLACK_WEBHOOK="${SLACK_WEBHOOK_URL:-}"
DISCORD_WEBHOOK="${DISCORD_WEBHOOK_URL:-}"
TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-}"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-}"

# Alert thresholds
ALERT_ON_SEVERITY="CRITICAL HIGH MEDIUM"  # Don't alert on LOW or INFO

# =============================================================================
# Helper Functions
# =============================================================================

log_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" >> "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [SUCCESS] $1" >> "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARN] $1" >> "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" >> "$LOG_FILE"
}

log_alert() {
    echo -e "${RED}[🚨 ALERT]${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ALERT] $1" >> "$LOG_FILE"
}

show_help() {
    cat << EOF
${CYAN}╔═══════════════════════════════════════════════════════════╗
║     Imperial Security Alert System — El Pregonero             ║
╠═══════════════════════════════════════════════════════════╣
║  USAGE:                                                   ║
║    $0 [--scan] [--slack] [--discord] [--telegram] [--all] ║
║                                                           ║
║  OPTIONS:                                                 ║
║    --scan     Run security scan first                     ║
║    --slack    Send alerts to Slack                        ║
║    --discord  Send alerts to Discord                      ║
║    --telegram Send alerts to Telegram                      ║
║    --all      Send to all channels                        ║
║    --test     Send test notification                      ║
║                                                           ║
║  EXAMPLES:                                                ║
║    $0 --scan --slack         # Scan + Slack alert         ║
║    $0 --all                  # All channels               ║
║    $0 --test                 # Test notification          ║
╚═══════════════════════════════════════════════════════════╝${NC}
EOF
}

# =============================================================================
# Security Scan Function
# =============================================================================

run_security_scan() {
    log_info "Running security scan..."
    
    if [[ ! -f "$SECTORS_DIR/bug-bounty.py" ]]; then
        log_error "bug-bounty.py not found in $SECTORS_DIR"
        return 1
    fi
    
    # Run scanner and save JSON report
    python3 "$SECTORS_DIR/bug-bounty.py" --full-scan --json > "$REPORT_FILE"
    
    if [[ $? -eq 0 ]]; then
        log_success "Security scan complete"
    else
        log_error "Security scan failed"
        return 1
    fi
}

# =============================================================================
# Report Parsing Functions
# =============================================================================

parse_report() {
    if [[ ! -f "$REPORT_FILE" ]]; then
        log_error "Report file not found: $REPORT_FILE"
        log_info "Run with --scan first or run bug-bounty.py manually"
        return 1
    fi
    
    # Extract key metrics using jq
    SCAN_ID=$(jq -r '.scan_id // "UNKNOWN"' "$REPORT_FILE")
    STATUS=$(jq -r '.status // "UNKNOWN"' "$REPORT_FILE")
    VULN_COUNT=$(jq -r '.vulnerabilities_found // 0' "$REPORT_FILE")
    DURATION=$(jq -r '.duration_seconds // 0' "$REPORT_FILE")
    
    # Count by severity
    CRITICAL_COUNT=$(jq -r '.severity_breakdown.CRITICAL // 0' "$REPORT_FILE")
    HIGH_COUNT=$(jq -r '.severity_breakdown.HIGH // 0' "$REPORT_FILE")
    MEDIUM_COUNT=$(jq -r '.severity_breakdown.MEDIUM // 0' "$REPORT_FILE")
    LOW_COUNT=$(jq -r '.severity_breakdown.LOW // 0' "$REPORT_FILE")
    
    log_info "Report parsed: $VULN_COUNT vulnerabilities found"
}

get_critical_vulnerabilities() {
    # Extract critical/high vulnerabilities for alerting
    jq -r '.vulnerabilities[] | select(.severity == "CRITICAL" or .severity == "HIGH")' "$REPORT_FILE"
}

# =============================================================================
# Notification Functions
# =============================================================================

send_slack_alert() {
    if [[ -z "$SLACK_WEBHOOK" ]]; then
        log_warn "SLACK_WEBHOOK_URL not set — skipping Slack notification"
        return 1
    fi
    
    log_info "Sending Slack alert..."
    
    # Build message based on severity
    if [[ "$STATUS" == "CRITICAL" ]]; then
        COLOR="danger"
        EMOJI="🚨"
        TITLE="CRITICAL SECURITY ALERT"
    elif [[ "$CRITICAL_COUNT" -gt 0 || "$HIGH_COUNT" -gt 0 ]]; then
        COLOR="warning"
        EMOJI="⚠️"
        TITLE="Security Vulnerabilities Detected"
    else
        COLOR="good"
        EMOJI="✅"
        TITLE="Security Scan Complete"
    fi
    
    # Build Slack payload
    PAYLOAD=$(cat <<EOF
{
    "attachments": [
        {
            "color": "$COLOR",
            "author_name": "Imperial Security Scanner",
            "title": "$EMOJI $TITLE",
            "text": "Scan ID: \`$SCAN_ID\`\nDuration: \`$DURATION\` seconds",
            "fields": [
                {
                    "title": "Critical",
                    "value": "$CRITICAL_COUNT",
                    "short": true
                },
                {
                    "title": "High",
                    "value": "$HIGH_COUNT",
                    "short": true
                },
                {
                    "title": "Medium",
                    "value": "$MEDIUM_COUNT",
                    "short": true
                },
                {
                    "title": "Low",
                    "value": "$LOW_COUNT",
                    "short": true
                }
            ],
            "footer": "Sector 09 Security | El Pregonero",
            "ts": $(date +%s)
        }
    ]
}
EOF
)
    
    # Send to Slack
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST \
        -H 'Content-type: application/json' \
        --data "$PAYLOAD" \
        "$SLACK_WEBHOOK")
    
    if [[ "$RESPONSE" == "200" ]]; then
        log_success "Slack alert sent"
        return 0
    else
        log_error "Slack alert failed (HTTP $RESPONSE)"
        return 1
    fi
}

send_discord_alert() {
    if [[ -z "$DISCORD_WEBHOOK" ]]; then
        log_warn "DISCORD_WEBHOOK_URL not set — skipping Discord notification"
        return 1
    fi
    
    log_info "Sending Discord alert..."
    
    # Build message based on severity
    if [[ "$STATUS" == "CRITICAL" ]]; then
        COLOR=16711680  # Red
        EMOJI="🚨"
        TITLE="🚨 CRITICAL SECURITY ALERT"
    elif [[ "$CRITICAL_COUNT" -gt 0 || "$HIGH_COUNT" -gt 0 ]]; then
        COLOR=16753920  # Orange
        EMOJI="⚠️"
        TITLE="⚠️ Security Vulnerabilities Detected"
    else
        COLOR=65280  # Green
        EMOJI="✅"
        TITLE="✅ Security Scan Complete"
    fi
    
    # Build Discord payload
    PAYLOAD=$(cat <<EOF
{
    "embeds": [
        {
            "title": "$TITLE",
            "color": $COLOR,
            "description": "**Scan ID:** \`$SCAN_ID\`\n**Duration:** \`$DURATION\` seconds",
            "fields": [
                {
                    "name": "🔴 Critical",
                    "value": "$CRITICAL_COUNT",
                    "inline": true
                },
                {
                    "name": "🟠 High",
                    "value": "$HIGH_COUNT",
                    "inline": true
                },
                {
                    "name": "🟡 Medium",
                    "value": "$MEDIUM_COUNT",
                    "inline": true
                },
                {
                    "name": "🟢 Low",
                    "value": "$LOW_COUNT",
                    "inline": true
                }
            ],
            "footer": {
                "text": "Sector 09 Security | El Pregonero"
            },
            "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
        }
    ]
}
EOF
)
    
    # Send to Discord
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST \
        -H 'Content-type: application/json' \
        --data "$PAYLOAD" \
        "$DISCORD_WEBHOOK")
    
    if [[ "$RESPONSE" == "204" || "$RESPONSE" == "200" ]]; then
        log_success "Discord alert sent"
        return 0
    else
        log_error "Discord alert failed (HTTP $RESPONSE)"
        return 1
    fi
}

send_telegram_alert() {
    if [[ -z "$TELEGRAM_BOT_TOKEN" || -z "$TELEGRAM_CHAT_ID" ]]; then
        log_warn "TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID not set — skipping Telegram"
        return 1
    fi
    
    log_info "Sending Telegram alert..."
    
    # Build message based on severity
    if [[ "$STATUS" == "CRITICAL" ]]; then
        EMOJI="🚨"
        TITLE="*CRITICAL SECURITY ALERT*"
    elif [[ "$CRITICAL_COUNT" -gt 0 || "$HIGH_COUNT" -gt 0 ]]; then
        EMOJI="⚠️"
        TITLE="*Security Vulnerabilities Detected*"
    else
        EMOJI="✅"
        TITLE="*Security Scan Complete*"
    fi
    
    # Build Telegram message (Markdown format)
    MESSAGE=$(cat <<EOF
$EMOJI $TITLE

*Scan ID:* \`$SCAN_ID\`
*Duration:* \`$DURATION\` seconds

*Vulnerabilities:*
🔴 Critical: $CRITICAL_COUNT
🟠 High: $HIGH_COUNT
🟡 Medium: $MEDIUM_COUNT
🟢 Low: $LOW_COUNT

_Sector 09 Security | El Pregonero_
EOF
)
    
    # Send to Telegram
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST \
        -H 'Content-type: application/json' \
        --data "{
            \"chat_id\": \"$TELEGRAM_CHAT_ID\",
            \"text\": \"$MESSAGE\",
            \"parse_mode\": \"Markdown\"
        }" \
        "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage")
    
    if [[ "$RESPONSE" == "200" ]]; then
        log_success "Telegram alert sent"
        return 0
    else
        log_error "Telegram alert failed (HTTP $RESPONSE)"
        return 1
    fi
}

send_test_notification() {
    log_info "Sending test notifications..."
    
    # Create fake report for testing
    cat > "$REPORT_FILE" <<EOF
{
    "scan_id": "TEST-$(date +%Y%m%d-%H%M%S)",
    "status": "PASS",
    "vulnerabilities_found": 0,
    "duration_seconds": 1.5,
    "severity_breakdown": {
        "CRITICAL": 0,
        "HIGH": 0,
        "MEDIUM": 0,
        "LOW": 0
    }
}
EOF
    
    parse_report
    
    local success=0
    local total=0
    
    if [[ -n "$SLACK_WEBHOOK" ]]; then
        ((total++))
        send_slack_alert && ((success++))
    fi
    
    if [[ -n "$DISCORD_WEBHOOK" ]]; then
        ((total++))
        send_discord_alert && ((success++))
    fi
    
    if [[ -n "$TELEGRAM_BOT_TOKEN" && -n "$TELEGRAM_CHAT_ID" ]]; then
        ((total++))
        send_telegram_alert && ((success++))
    fi
    
    if [[ $total -eq 0 ]]; then
        log_warn "No notification channels configured"
        log_info "Set SLACK_WEBHOOK_URL, DISCORD_WEBHOOK_URL, or TELEGRAM_* env vars"
    else
        log_success "Test complete: $success/$total notifications sent"
    fi
}

# =============================================================================
# Main Execution
# =============================================================================

main() {
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║     Imperial Security Alert System — El Pregonero         ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Parse arguments
    RUN_SCAN=false
    SEND_SLACK=false
    SEND_DISCORD=false
    SEND_TELEGRAM=false
    SEND_ALL=false
    RUN_TEST=false
    
    if [[ $# -eq 0 ]]; then
        show_help
        exit 0
    fi
    
    for arg in "$@"; do
        case "$arg" in
            --scan)
                RUN_SCAN=true
                ;;
            --slack)
                SEND_SLACK=true
                ;;
            --discord)
                SEND_DISCORD=true
                ;;
            --telegram)
                SEND_TELEGRAM=true
                ;;
            --all)
                SEND_ALL=true
                ;;
            --test)
                RUN_TEST=true
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $arg"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Run test if requested
    if [[ "$RUN_TEST" == true ]]; then
        send_test_notification
        exit 0
    fi
    
    # Run security scan if requested
    if [[ "$RUN_SCAN" == true ]]; then
        run_security_scan || exit 1
    fi
    
    # Parse report
    parse_report || exit 1
    
    # Display summary
    echo ""
    log_info "════════════════════════════════════════════"
    log_info "  SECURITY SCAN SUMMARY"
    log_info "════════════════════════════════════════════"
    log_info "  Scan ID: $SCAN_ID"
    log_info "  Status: $STATUS"
    log_info "  Duration: ${DURATION}s"
    log_info "  ─────────────────────────────────────"
    log_info "  🔴 Critical: $CRITICAL_COUNT"
    log_info "  🟠 High: $HIGH_COUNT"
    log_info "  🟡 Medium: $MEDIUM_COUNT"
    log_info "  🟢 Low: $LOW_COUNT"
    log_info "════════════════════════════════════════════"
    echo ""
    
    # Determine if alerts should be sent
    SHOULD_ALERT=false
    
    if [[ "$STATUS" == "CRITICAL" ]]; then
        SHOULD_ALERT=true
        log_alert "CRITICAL status detected — alerting enabled"
    fi
    
    if [[ "$CRITICAL_COUNT" -gt 0 || "$HIGH_COUNT" -gt 0 ]]; then
        SHOULD_ALERT=true
        log_alert "Critical/High vulnerabilities found — alerting enabled"
    fi
    
    # Send notifications
    local notifications_sent=0
    
    if [[ "$SEND_ALL" == true ]] || [[ "$SEND_SLACK" == true ]]; then
        if [[ "$SHOULD_ALERT" == true ]]; then
            send_slack_alert && ((notifications_sent++)) || true
        else
            log_info "Skipping Slack — no critical issues"
        fi
    fi
    
    if [[ "$SEND_ALL" == true ]] || [[ "$SEND_DISCORD" == true ]]; then
        if [[ "$SHOULD_ALERT" == true ]]; then
            send_discord_alert && ((notifications_sent++)) || true
        else
            log_info "Skipping Discord — no critical issues"
        fi
    fi
    
    if [[ "$SEND_ALL" == true ]] || [[ "$SEND_TELEGRAM" == true ]]; then
        if [[ "$SHOULD_ALERT" == true ]]; then
            send_telegram_alert && ((notifications_sent++)) || true
        else
            log_info "Skipping Telegram — no critical issues"
        fi
    fi
    
    # Final status
    echo ""
    if [[ "$SHOULD_ALERT" == true ]]; then
        log_success "Alerts sent: $notifications_sent channel(s)"
    else
        log_success "System nominal — no critical alerts needed"
    fi
    
    # Exit with error code if critical vulnerabilities found
    if [[ "$STATUS" == "CRITICAL" ]]; then
        log_error "CRITICAL vulnerabilities detected — review report immediately"
        exit 1
    fi
    
    exit 0
}

# Run main
main "$@"
