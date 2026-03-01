# QWEN.md — Root Workspace Context

**Workspace:** Turbo-the-tech-dev Root Orchestration
**Platform:** Termux (Android)
**Organization:** [@Turbo-the-tech-dev](https://github.com/Turbo-the-tech-dev)
**Primary Branch:** `27-claude`

---

## 📋 Project Overview

This is the **root workspace repository** that orchestrates 25+ sub-repositories spanning:
- Educational materials and AI/ML systems
- Electrical engineering tools (NEC compliance, conduit bending)
- Automation scripts and CLI utilities
- Full-stack development projects

### Key Projects

| Project | Technology | Purpose |
|---------|------------|---------|
| **Electrician** | React Native + Expo | Electrical calculator app |
| **sovereign-circuit-academy** | Flutter + Riverpod | NEC codes, conduit bending, load calculators |
| **DEATHSTAR** | Bash CLI | Automation tool suite |
| **Electrical-Core-API** | .NET Core | Electrical calculations API |
| **Todolite** | Vanilla JS | Minimalist to-do app |

See `MASTER-INDEX.md` for complete catalog of all 25 repositories.

---

## 🗂️ Directory Structure

```
/root (orchestration root)
├── MASTER-INDEX.md              # Complete repo catalog
├── CLAUDE.md                    # Claude Code guidance
├── HOLOCRON.md                  # Master command center (priorities, aliases)
├── docker-compose.yml           # Service orchestration
├── push_all_repos.sh            # Deploy all repos to GitHub
├── cleanup_local_repos.sh       # Post-deploy cleanup
│
├── scripts_workspace/           # Automation suite
│   ├── utilities/               # Core utility scripts
│   ├── drive-management/        # Google Drive sync
│   ├── git-training/            # Git workflows
│   ├── master-control/          # Repo verification
│   └── documentation/           # Markdown guides
│
├── files/                       # File organization (53 extensions)
│   ├── sh/, py/, js/, ts/       # Source code by extension
│   ├── md/, html/, css/         # Documentation & web
│   └── json/, yaml/             # Configuration
│
├── shifts/                      # Shift work tracking
│   ├── 1/, 2/, 3/               # Individual shift workspaces
│   └── master/                  # Consolidated status
│
├── special_drive/               # Organized content
│   ├── 01_CRITICAL/             # Critical notes & strategy
│   ├── 02_PROJECTS/             # Project files
│   ├── 06_ELECTRICAL/           # Electrical engineering
│   └── 07_ARCHIVE/              # Archived content
│
├── Electrical-Core-API/         # .NET Core API service
│   └── src/                     # Domain, Application, Infrastructure
│
├── agents/                      # AI agent configurations
│   └── theoggrant/              # Neuro-symbolic pipeline
│
├── _best-practices/             # Best practice guides
├── _ubuntu/, _kali/             # Distro templates
└── __THE_SANDBOX__/             # Nested testing sandboxes
```

---

## 🚀 Building and Running

### Deploy and Manage Repositories

```bash
# Push all local repositories to GitHub
/root/push_all_repos.sh

# Clean up local repository copies (after successful push)
/root/cleanup_local_repos.sh

# Verify repository status
bash scripts_workspace/master-control/verify-repos.sh
```

### File Organization

```bash
# Organize files by extension (dry-run first)
bash file_collector.sh --dry-run
bash file_collector.sh --resume
```

### Git Workflow

```bash
# Standard git workflow with commit message
bash scripts_workspace/git-training/git-workflow.sh . "feat: message"

# Clone scripts repository
bash scripts_workspace/drive-management/clone-scripts-repo.sh
```

### Sub-Project Development

```bash
# React Native (Electrician)
cd Turbo-Repos/Electrician
npm install && npm test

# Flutter (sovereign-circuit-academy)
cd sovereign-circuit-academy/vader-academy-app
flutter pub get && flutter run

# Python tools
python3 sovereign-circuit-academy/box_fill_calculator.py

# .NET Core API
cd Electrical-Core-API
dotnet run
```

### Docker Services

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f
```

---

## 📝 Development Conventions

### Commit Messages (Conventional Commits)

```
type(scope): brief message

Longer explanation if needed.
```

**Types:** `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`, `test:`

**Examples:**
```
feat(file-collector): add batch processing for large file sets
fix(symlink): correct termux home path resolution
docs(readme): update quick start section
```

### Branch Naming

```
feature/short-description
fix/short-description
docs/short-description
refactor/short-description
chore/short-description
```

### Bash Scripts

```bash
#!/usr/bin/env bash
set -euo pipefail

# Use 2-space indentation
# Quote all variables: "${var}"
# Use readonly for constants
# Add header comments explaining purpose
```

### Python

- Follow PEP 8
- Use type hints
- Write docstrings for all functions

### Markdown

- Use `#` for headings
- Keep line length under 100 characters
- Use backticks for code references

---

## 🎯 Platform Constraints

**Primary Environment:** Termux (Android)
- No native build toolchain (Xcode/Android Studio)
- Node.js/npm projects use Expo for React Native
- Flutter uses `flutter pub/run` commands
- Python scripts run directly
- Bash is the primary CLI tool

---

## 📊 Key Files Reference

| File | Purpose |
|------|---------|
| `MASTER-INDEX.md` | Catalog of all 25 GitHub repositories |
| `CLAUDE.md` | Project guidance for Claude Code |
| `HOLOCRON.md` | Daily priorities, navigation aliases, metrics |
| `CONTRIBUTING.md` | Contribution guidelines |
| `CODE_OF_CONDUCT.md` | Community standards |
| `docker-compose.yml` | Service orchestration |
| `scripts_workspace/README.md` | Script development guide |
| `files/README.md` | File organization system |

---

## 🔧 Dark-Key Aliases (from HOLOCRON.md)

```bash
h    # The Holocron (HOLOCRON.md)
t    # Today's Conquests (active priorities)
s    # System Status
e    # Electrical Portal
v    # The Vault (Imperial Directives)
vp   # VP Strategy
m    # Mason's AI Workflow
eod  # Mason's EOD Report
```

---

## 🤖 Automation & CI/CD

### GitHub Actions Workflows

Located in `.github/workflows/`:

| Workflow | Schedule | Purpose |
|----------|----------|---------|
| `monthly-report.yml` | 1st of month | Fleet-wide status report |
| `weekly-metrics.yml` | Weekly | Repository metrics tracking |
| `secret-scan.yml` | On push | Security scanning |
| `gemini-*.yml` | Various | Gemini AI integrations |

### Neuro-Symbolic Pipeline

The `agents/theoggrant/` directory contains the neuro-symbolic CI/CD blueprint:
- LLM as Creative Engine for code generation
- Z3 SMT Solver as Logical Auditor for formal verification
- Feedback loop for automated repair

---

## 📈 Testing Practices

```bash
# Dry-run tests (where available)
bash script_name.sh --dry-run

# Run project tests
npm test          # Node.js projects
pytest            # Python projects
flutter test      # Flutter projects
dotnet test       # .NET projects
```

**Platform Testing:** Always test on Termux (primary platform) before deployment.

---

## 🔐 Security

- See `SECURITY.md` for vulnerability reporting
- Automated secret scanning via GitHub Actions
- Never commit API keys, credentials, or secrets
- Use `.env` files for sensitive configuration

---

## 📞 Support

- **Issues:** Use GitHub issue templates (`.github/ISSUE_TEMPLATE/`)
- **Discussions:** https://github.com/Turbo-the-tech-dev/root/discussions
- **Contact:** turbo-dev@example.com

---

**Status:** Active | **Last Updated:** 2026-02-28
