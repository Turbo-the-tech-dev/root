#!/usr/bin/env bash
# Resolving Root Issue #2: Capacity Automation
# Sector 05 (GitHub) Bridge

LOG_FILE="/data/data/com.termux/files/home/epic/root/logs/daily_$(date +%Y%m%d).log"

echo "[*] FETCHING TELEMETRY FROM SECTOR 08 (AWS)..."
# Count today's successful logs in the SCA (Super Cat Archive)
if [ -f "$LOG_FILE" ]; then
    LOG_COUNT=$(grep -c "SUCCESS" "$LOG_FILE")
else
    LOG_COUNT=0
fi
echo "[+] Telemetry Count: $LOG_COUNT"

echo "[*] QUERYING GITHUB GRAPHQL (SECTOR 05)..."
# In a real environment, GITHUB_TOKEN must be set
if [ -z "$GITHUB_TOKEN" ]; then
    echo "[!] WARNING: GITHUB_TOKEN not set. Mocking PR_COUNT for demonstration."
    PR_COUNT=2
else
    # Pull PR stats using the Bearer token
    PR_COUNT=$(curl -s -H "Authorization: bearer $GITHUB_TOKEN" \
         -X POST -d '{ "query": "query { viewer { repository(name: \"root\") { pullRequests(states:MERGED) { totalCount } } } }" }' \
         https://api.github.com/graphql | jq '.data.viewer.repository.pullRequests.totalCount' || echo "0")
fi
echo "[+] PR Count: $PR_COUNT"

# --- THE FORMULA ---
# Capacity % = (Merged PRs + Successful Builds) / (Daily Quota of 10 Tasks) * 100
TOTAL_ACUITY=$((LOG_COUNT + PR_COUNT))
CAPACITY=$(( (TOTAL_ACUITY * 100) / 10 ))

# Cap at 100 unless override is triggered
if [ $CAPACITY -gt 100 ]; then
    CAPACITY=100
fi

# SNEAKY OVERRIDE: If the first argument is '141', force the capacity.
if [ "$1" == "141" ]; then
    CAPACITY="141"
fi

echo "[*] PUSHING TO FIRESTORE (SECTOR 06)..."
# This updates the document that your mobile app listens to
python3 /data/data/com.termux/files/home/epic/root/sectors/06-firestore/update_capacity.py --value $CAPACITY

echo "[+] ISSUE #2 RESOLVED: CAPACITY SET TO $CAPACITY%"
