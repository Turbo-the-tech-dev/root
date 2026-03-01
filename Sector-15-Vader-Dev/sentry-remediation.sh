#!/usr/bin/env bash
# Sector 15: Vader Dev - Autonomous Imperial Sentry
# "The Empire never sleeps. The Empire never fails."

set -uo pipefail

# Configuration
CHECK_INTERVAL=60
MAX_FAILURES=3
LOG_FILE="./Sector-15-Vader-Dev/sentry-log.json"
JOURNAL_ENDPOINT="${FIRESTORE_WEBHOOK:-https://firestore.googleapis.com/v1/projects/imperial-fleet/databases/(default)/documents/sentry-events}"

# Services to monitor
SERVICES=("imperial-mcp-server" "turbo-remote-cache" "firestore-sync")

echo "🛡️  IMPERIAL SENTRY ACTIVATED - SECTOR 15"
echo "=========================================="
echo "Monitoring interval: ${CHECK_INTERVAL}s"
echo "Max failures before escalation: $MAX_FAILURES"
echo ""

# Initialize failure counters
declare -A FAILURE_COUNTS
for svc in "${SERVICES[@]}"; do
    FAILURE_COUNTS[$svc]=0
done

log_event() {
    local level="$1"
    local message="$2"
    local sector="${3:-15}"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    echo "[$level] $message"
    
    # Log to JSON
    echo "{\"timestamp\": \"$timestamp\", \"level\": \"$level\", \"message\": \"$message\", \"sector\": $sector}" >> "$LOG_FILE"
    
    # Broadcast to Journal
    curl -X POST \
      -H "Content-Type: application/json" \
      -d "{\"fields\": {\"level\": {\"stringValue\": \"$level\"}, \"message\": {\"stringValue\": \"$message\"}, \"sector\": {\"stringValue\": \"$sector\"}, \"timestamp\": {\"timestampValue\": \"$timestamp\"}}}" \
      "$JOURNAL_ENDPOINT" 2>/dev/null || true
}

heal_service() {
    local service="$1"
    log_event "INFO" "Initiating self-healing protocol for $service"
    
    # Capture error logs
    local error_logs=$(journalctl -u "$service" -n 50 --no-pager 2>/dev/null || echo "No logs available")
    
    # Attempt standard fixes
    case "$service" in
        "imperial-mcp-server")
            log_event "ACTION" "Restarting MCP Neural Bridge..."
            systemctl restart "$service" 2>/dev/null || {
                # Fallback: Try to restart manually
                pkill -f "memory-server.js" 2>/dev/null || true
                cd ./Sector-012-MCP-Bridge && node memory-server.js &
            }
            ;;
        "turbo-remote-cache")
            log_event "ACTION" "Clearing remote cache..."
            rm -rf ./.turbo/remote-cache/* 2>/dev/null || true
            ;;
        "firestore-sync")
            log_event "ACTION" "Re-establishing Firestore connection..."
            # Touch the sync marker to trigger reconnect
            touch ./Sector-06-Firestore/.resync-trigger
            ;;
        *)
            log_event "ACTION" "Generic restart for $service"
            systemctl restart "$service" 2>/dev/null || true
            ;;
    esac
    
    # Wait and verify
    sleep 5
    if systemctl is-active --quiet "$service" 2>/dev/null || pgrep -f "$service" > /dev/null; then
        log_event "SUCCESS" "✅ Service $service healed successfully"
        FAILURE_COUNTS[$service]=0
        return 0
    else
        log_event "ERROR" "❌ Failed to heal $service"
        return 1
    fi
}

# Main monitoring loop
while true; do
    for service in "${SERVICES[@]}"; do
        # Check if service is healthy
        if systemctl is-active --quiet "$service" 2>/dev/null || pgrep -f "$service" > /dev/null 2>&1; then
            # Service is running, reset failure count
            if [ ${FAILURE_COUNTS[$service]} -gt 0 ]; then
                log_event "INFO" "Service $service recovered"
                FAILURE_COUNTS[$service]=0
            fi
        else
            # Service is down
            FAILURE_COUNTS[$service]=$((FAILURE_COUNTS[$service] + 1))
            log_event "WARNING" "Service $service is DOWN (Failure ${FAILURE_COUNTS[$service]}/$MAX_FAILURES)"
            
            if [ ${FAILURE_COUNTS[$service]} -le $MAX_FAILURES ]; then
                heal_service "$service"
            else
                log_event "CRITICAL" "🔴 MAX FAILURES REACHED for $service"
                log_event "CRITICAL" "Red Alert: Manual intervention required"
                
                # Send emergency notification
                curl -X POST \
                  -H "Content-Type: application/json" \
                  -d '{"fields": {"alert": {"stringValue": "CRITICAL"}, "service": {"stringValue": "'"$service"'"}, "message": {"stringValue": "Sentry failed to heal after 3 attempts"}}}' \
                  "$JOURNAL_ENDPOINT" 2>/dev/null || true
            fi
        fi
    done
    
    # Heartbeat log every 10 minutes
    if [ $(($(date +%s) % 600)) -lt $CHECK_INTERVAL ]; then
        log_event "HEARTBEAT" "Imperial Sentry is operational - 155% Efficiency"
    fi
    
    sleep $CHECK_INTERVAL
done
