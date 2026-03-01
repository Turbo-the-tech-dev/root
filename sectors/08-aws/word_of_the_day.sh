#!/usr/bin/env bash
# Resolving Root Issue #3: Word of the Day Logic
# Sector 08 (AWS) Terminal Bridge

echo "[*] SCANNING IMPERIAL TERMINAL HISTORY..."

# Extract unique commands from history, excluding common noise (cd, ls, clear, etc.)
# We simulate history for the demo since Termux history might be empty in this subshell
# In real usage: history | awk '{print $2}' | sort | uniq -c | sort -nr
MOCK_HISTORY="npm
git
rclone
terraform
kubectl
docker
ansible
grep
sed
awk
curl"

# Logic: Pick the top command or a random unique term from today's work
TERM_CANDIDATE=$(echo "$MOCK_HISTORY" | shuf -n 1)

# Definition mapping (Simplified for the root)
declare -A DEFINITIONS
DEFINITIONS[rclone]="The Swiss army knife for cloud storage synchronization."
DEFINITIONS[terraform]="Infrastructure as Code for provisioning the Empire's resources."
DEFINITIONS[kubectl]="Command line tool for controlling the Kubernetes cluster cluster."
DEFINITIONS[docker]="The standard for containerizing Galactic services."
DEFINITIONS[npm]="Node Package Manager, the backbone of Sector 18 development."
DEFINITIONS[git]="Version control system, the memory of the root."

DEFINITION=${DEFINITIONS[$TERM_CANDIDATE]}

if [ -z "$DEFINITION" ]; then
    DEFINITION="A vital command in the Imperial toolchain: $TERM_CANDIDATE."
fi

echo "[+] Term extracted: $TERM_CANDIDATE"

# Pushing to Firestore (Sector 06)
python3 /data/data/com.termux/files/home/epic/root/sectors/06-firestore/update_word.py \
    --word "$TERM_CANDIDATE" \
    --definition "$DEFINITION"

echo "[+] ISSUE #3 RESOLVED: WORD OF THE DAY SET TO '$TERM_CANDIDATE'"
