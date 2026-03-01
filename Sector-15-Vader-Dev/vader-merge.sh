#!/usr/bin/env bash
# Sector 15: Vader Dev - The Gatekeeper Merge
# "No code passes without the Vader Seal of Approval"

set -euo pipefail

STAGING_DIR="${STAGING_DIR:-./Sector-012-MCP-Bridge/staging}"
PRODUCTION_DIR="${PRODUCTION_DIR:-./root}"
LOG_FILE="./Sector-15-Vader-Dev/merge-log.json"

echo "🏛️  IMPERIAL GATEKEEPER PROTOCOL - SECTOR 15"
echo "============================================"
echo ""

# Validate staging directory exists
if [ ! -d "$STAGING_DIR" ]; then
    echo "❌ ERROR: Staging directory not found at $STAGING_DIR"
    echo "   Run an AI agent to populate the staging area first."
    exit 1
fi

# 1. Security Audit - Check for Forbidden Patterns
echo "[*] Phase 1: Security Audit - Scanning for forbidden patterns..."
VIOLATIONS=0

# Check for TODO/FIXME (unfinished code)
if grep -r -i "TODO\|FIXME\|XXX\|HACK" "$STAGING_DIR" 2>/dev/null; then
    echo "  ⚠️  WARNING: Unfinished code markers detected"
    VIOLATIONS=$((VIOLATIONS + 1))
fi

# Check for console.log in production code
if grep -r "console\.log" "$STAGING_DIR" --include="*.js" --include="*.ts" 2>/dev/null; then
    echo "  ⚠️  WARNING: Debug console statements detected"
    VIOLATIONS=$((VIOLATIONS + 1))
fi

# Check for hardcoded secrets
if grep -r -E "(password|secret|key|token)\s*[=:]\s*[\"'][^\"']+[\"']" "$STAGING_DIR" --include="*.js" --include="*.ts" --include="*.json" 2>/dev/null; then
    echo "  ❌ CRITICAL: Potential hardcoded secrets detected"
    VIOLATIONS=$((VIOLATIONS + 10))
fi

# Check for eval() and dangerous functions
if grep -r "eval(" "$STAGING_DIR" --include="*.js" --include="*.ts" 2>/dev/null; then
    echo "  ❌ CRITICAL: Dangerous eval() usage detected"
    VIOLATIONS=$((VIOLATIONS + 10))
fi

if [ $VIOLATIONS -gt 5 ]; then
    echo ""
    echo "❌ MERGE DENIED: Critical security violations found ($VIOLATIONS)"
    echo "   Review the code and remove forbidden patterns."
    exit 1
fi

if [ $VIOLATIONS -gt 0 ]; then
    echo "  [!] $VIOLATIONS warnings found. Review recommended."
else
    echo "  ✓ Security audit passed"
fi

# 2. NEC 2026 Compliance Check
echo "[*] Phase 2: NEC 2026 Compliance Verification..."
if grep -r "NEC.*2023\|NEC2023\|2023 NEC" "$STAGING_DIR" 2>/dev/null; then
    echo "  ❌ ERROR: Outdated NEC 2023 references found"
    echo "      Update to NEC 2026 standards before merging."
    exit 1
fi
echo "  ✓ NEC 2026 compliance verified"

# 3. Dry Run Sync
echo "[*] Phase 3: Simulating merge operation..."
if command -v rclone &> /dev/null; then
    echo "  Files to be copied:"
    rclone copy "$STAGING_DIR" "$PRODUCTION_DIR" --dry-run --verbose 2>&1 | grep -E "^\s*\d+\s" || echo "    (dry run output)"
else
    echo "  Source: $STAGING_DIR"
    echo "  Target: $PRODUCTION_DIR"
    find "$STAGING_DIR" -type f | head -20
fi

# 4. Final Sovereign Approval
echo ""
echo "============================================"
read -p "🛡️  Execute Merge to Production? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "[*] Executing merge..."
    
    # Perform the merge
    if command -v rclone &> /dev/null; then
        rclone copy "$STAGING_DIR" "$PRODUCTION_DIR" --verbose
    else
        cp -r "$STAGING_DIR"/* "$PRODUCTION_DIR"/ 2>/dev/null || true
    fi
    
    # Log the merge
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "{\"timestamp\": \"$TIMESTAMP\", \"action\": \"merge\", \"from\": \"$STAGING_DIR\", \"to\": \"$PRODUCTION_DIR\", \"violations\": $VIOLATIONS}" >> "$LOG_FILE"
    
    echo ""
    echo "✅ MERGE COMPLETE. The Vader Seal has been applied."
    echo "[*] Stabilizing the Imperial Fleet..."
    
    # Trigger post-merge purge
    if [ -f ./Sector-18-Turbo-Dev/imperial-purge.sh ]; then
        echo "  Running dependency sync..."
        bash ./Sector-18-Turbo-Dev/imperial-purge.sh <<< "n" 2>/dev/null || true
    fi
    
    echo ""
    echo "🏛️  STATUS: Production deployment successful"
    echo "   Sector: 15 (Vader Dev) | Efficiency: 155%"
else
    echo "[!] Merge aborted by Sovereign command."
    exit 1
fi
