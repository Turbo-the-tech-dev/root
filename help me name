#!/data/data/com.termux/files/usr/bin/bash
# 🏛️ Imperial Sector Navigator v1.0 – High-Acuity Search Protocol
# Usage: sector-search 17    OR    sector-search "Flutter"    OR    sector-search Vader

HIERARCHY_FILE="$HOME/Imperial/root/MASTER-INDEX.md"

if [ ! -f "$HIERARCHY_FILE" ]; then
  echo "⚠️  MASTER-INDEX.md not found. Cloning now for full synchronization..."
  mkdir -p ~/Imperial && cd ~/Imperial && git clone https://github.com/Turbo-the-tech-dev/root root
  HIERARCHY_FILE="$HOME/Imperial/root/MASTER-INDEX.md"
fi

QUERY="$1"
echo "🔍 Imperial Search Engine: Querying '$QUERY' across Sectors 01–20..."

# High-acuity extraction (supports number, name, or keyword)
RESULT=$(awk -v q="$QUERY" '
  /\| \*\*[0-9][0-9]\*\* / || /\| \*\*[A-Za-z]/ {
    if (tolower($0) ~ tolower(q) || $0 ~ q) print "🏛️ MATCH:\n" $0
  }
' "$HIERARCHY_FILE")

if [ -n "$RESULT" ]; then
  echo "$RESULT"
  echo ""
  echo "🛠️  Strategic Command Example: 'Invoke Sector 01 for architecture on Sector 17 output audited by Sector 15'"
else
  echo "❌ No match in the Imperial Registry. The Empire demands precision."
  echo "Valid examples: 01–20, Claude, Flutter, Vader Dev, Turbo Dev"
fi

echo "*The Empire is only as strong as its organization.*"