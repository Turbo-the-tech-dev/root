# Sector Search — Imperial Navigation Script

## Overview

Zero-cost `awk`-based search protocol for navigating the Imperial Hierarchy (Sectors 01-20).

**Hiroshi-approved** — Execution time <2ms (Sovereign Standard achieved)

---

## Installation

### Option 1: Manual Execution

```bash
cd ~/Imperial/root/scripts
./sector-search.sh <query>
```

### Option 2: Global Alias (Recommended)

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# Source Imperial aliases
source ~/Imperial/root/scripts/imperial-aliases.sh
```

Then reload your shell:

```bash
source ~/.bashrc  # or source ~/.zshrc
```

---

## Usage

### Basic Search

```bash
# Search by sector number
s 17

# Search by name
s Vader
s Flutter
s AWS
```

### Neural Jump (Auto-CD)

```bash
# Search and jump to sector directory
s 08 -j

# After search, type 'y' to cd into the sector
```

### Vader-Gate Security Scan

```bash
# Scan sector for secrets before accessing
s 06 -v  # Firestore sector
s 08 -v  # AWS sector
```

**Detects:**
- AWS Access Keys (AKIA...)
- GitHub Tokens (ghp_...)
- Private Keys
- Hardcoded passwords

### Combined Operations

```bash
# Search + Jump + Vader-Gate
s 17 -j -v
```

---

## Quick Aliases

| Alias | Command | Purpose |
|-------|---------|---------|
| `s08` | `s 08 -j` | Jump to AWS sector |
| `s17` | `s 17 -j` | Jump to Flutter sector |
| `s19` | `s 19 -j` | Jump to Expo sector |
| `vader06` | `s 06 -v` | Scan Firestore for secrets |
| `vader08` | `s 08 -v` | Scan AWS for secrets |
| `s-bench` | `s -b` | Run performance benchmark |
| `s-deploy` | `s -d` | Deploy to AWS RHEL |

---

## Features

### 1. Sovereign Search Protocol

- **Zero-cost abstraction** — Pure `awk`, no external dependencies
- **Case-insensitive** — Matches "vader", "Vader", "VADER"
- **Fuzzy matching** — Partial matches work ("Flut" finds "Flutter")

### 2. Neural Jump

After finding a match:
- Shows sector README preview
- Offers to `cd` into directory
- Lists directory contents

### 3. Vader-Gate Security

Before accessing sensitive sectors:
- Scans for AWS keys
- Scans for GitHub tokens
- Scans for private keys
- Scans for hardcoded passwords
- Optional `gitleaks` integration for comprehensive scanning

### 4. Performance Benchmark

```bash
s -b
# Output: Search execution time: 1ms
# ✅ SOVEREIGN STANDARD achieved (<10ms)
```

### 5. AWS RHEL Deployment

Sync script and MASTER-INDEX to RHEL instance:

```bash
export RHEL_HOST=ec2-xxx.compute-1.amazonaws.com
export RHEL_USER=ec2-user
s -d
```

---

## Integration Points

### Angular Frontend (Sector 17)

Pipe search results via websocket:

```bash
# Example: Stream to dashboard
s 17 | wscat -c ws://localhost:8080/imperial-search
```

### GitHub Actions

Use in CI/CD for sector validation:

```yaml
- name: Validate sector structure
  run: |
    ./scripts/sector-search.sh 17
    ./scripts/sector-search.sh Vader -v
```

---

## 8-Hour Sprint Status

| Milestone | Status | Notes |
|-----------|--------|-------|
| 1641 — Deploy to RHEL | ⏳ Pending | Set RHEL_HOST/RHEL_USER |
| 1642 — Benchmark | ✅ Complete | <2ms (Sovereign Standard) |
| 1643 — Angular Frontend | ⏳ Pending | Websocket integration ready |
| 1650 — 165% Complete | 🔄 In progress | Search + Jump + Vader-Gate |

---

## Troubleshooting

### "MASTER-INDEX.md not found"

Ensure you're running from the correct directory:

```bash
cd ~/Imperial/root/scripts
./sector-search.sh 17
```

### "gitleaks not found"

Install for comprehensive scanning:

```bash
# Termux
pkg install gitleaks

# Or download from GitHub
wget https://github.com/zricethezav/gitleaks/releases/latest/download/gitleaks-linux-amd64.tar.gz
tar xz gitleaks-linux-amd64
sudo mv gitleaks-linux-amd64/gitleaks /usr/local/bin/
```

### Neural Jump doesn't cd

The script can't change your parent shell's directory. Use the alias:

```bash
# Add to .bashrc
alias s17='cd ~/Imperial/root/sectors/17-flutter'
```

---

*Last Updated: 2026-02-28*
*Hiroshi + Desmond approved — Zero-cost, Sovereign Standard performance.*
