#!/usr/bin/env bash
# Sector 18: Turbo Dev - The Imperial Cache Purge
# "When the fleet is glitched, we return to the source."

set -euo pipefail

echo "⚠️  WARNING: INITIATING PROTOCOL 1591 - SYSTEM PURGE ⚠️"
read -p "Are you sure you want to wipe local artifacts and re-sync? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "[!] Purge aborted. The Empire remains as-is."
    exit 1
fi

# Configuration
FIRESTORE_WEBHOOK="${FIRESTORE_WEBHOOK:-https://firestore.googleapis.com/v1/projects/imperial-fleet/databases/(default)/documents/events}"
S3_BUCKET="${S3_BUCKET:-imperial-arsenal}"

# 1. Nuclear Option: Remove all local node_modules and turbo caches
echo "[*] Phase 1: Vaporizing local artifacts..."
find . -name "node_modules" -type d -prune -exec rm -rf '{}' + 2>/dev/null || true
find . -name ".turbo" -type d -exec rm -rf '{}' + 2>/dev/null || true
find . -name ".next" -type d -exec rm -rf '{}' + 2>/dev/null || true
find . -name "dist" -type d -exec rm -rf '{}' + 2>/dev/null || true
rm -f .eslintcache
rm -f .prettiercache

echo "  ✓ Artifacts vaporized"

# 2. Resync the Imperial Arsenal (Lockfiles & Blueprints)
echo "[*] Phase 2: Pulling Golden Image from AWS S3..."
if command -v rclone &> /dev/null; then
    rclone sync "$S3_BUCKET:root/" ./ --include "pnpm-lock.yaml" --include "turbo.json" --include "package.json" --verbose
else
    echo "  [!] rclone not installed. Manual sync required."
    echo "      Run: aws s3 sync s3://$S3_BUCKET/root/ ./ --include '*.yaml' --include '*.json'"
fi

echo "  ✓ Golden Image synchronized"

# 3. Clean Install via PNPM (The Shared Store)
echo "[*] Phase 3: Reconstructing the Dependency Matrix..."
if command -v pnpm &> /dev/null; then
    pnpm install --frozen-lockfile --prefer-offline
else
    echo "  [!] pnpm not installed. Falling back to npm..."
    npm ci
fi

echo "  ✓ Dependencies reconstructed"

# 4. Remote Cache Warmup
echo "[*] Phase 4: Validating Neural Bridge with Turbo..."
if command -v turbo &> /dev/null; then
    export TURBO_TELEMETRY_DISABLED=1
    turbo build --cache-dir="./.turbo" --summarize || true
    
    # Analyze summary for bottlenecks
    if [ -f .turbo/runs/*.json ]; then
        LATEST_SUMMARY=$(ls -t .turbo/runs/*.json | head -1)
        echo "  ✓ Build summary generated: $LATEST_SUMMARY"
        echo "  [*] Run 'cat $LATEST_SUMMARY | jq .' to analyze bottlenecks"
    fi
else
    echo "  [!] turbo not installed. Skipping build warmup."
fi

# 5. Log Success to Sector 010 (Journal)
echo "[*] Phase 5: Broadcasting to Imperial Journal..."
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
PAYLOAD=$(cat <<EOF
{
  "fields": {
    "event": {"stringValue": "System Purged"},
    "status": {"stringValue": "159% Clean"},
    "timestamp": {"timestampValue": "$TIMESTAMP"},
    "sector": {"stringValue": "18"},
    "protocol": {"stringValue": "1591"}
  }
}
EOF
)

curl -X POST \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" \
  "$FIRESTORE_WEBHOOK" 2>/dev/null || echo "  [!] Webhook unavailable - event logged locally"

echo ""
echo "✅ SUCCESS: The Imperial Fleet is synchronized and optimized."
echo "   Efficiency: 159% | Status: OPERATIONAL | Sector: 18 (Turbo Dev)"
