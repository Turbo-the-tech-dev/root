# 🌟 Turbo-the-tech-dev/root

> **Root Workspace Orchestration** — A consolidated toolbox for educational materials, AI/ML systems, electrical engineering tools, and automation scripts.

**Organization:** [@Turbo-the-tech-dev](https://github.com/Turbo-the-tech-dev)  
**Platform:** Termux (Android)  
**Primary Branch:** `27-claude`  
**Status:** Active | **Last Updated:** 2026-02-28

---

## 📋 What This Repo Is

This is the **root workspace repository** that orchestrates 25+ sub-repositories spanning:

| Category | Repositories | Purpose |
|----------|--------------|---------|
| 🎓 **Educational** | 7 | Math fundamentals, viral problems, visual learning |
| 🤖 **AI/ML** | 8 | LLM fundamentals, prompt engineering, generative AI |
| ⚡ **Electrical** | 2 | NEC compliance, conduit bending, load calculators |
| 📐 **Math** | 3 | Concrete mathematics, mathematicians archive |
| 🔧 **Special Projects** | 5 | Reverse engineering, Julia programming, tooling |

See [**MASTER-INDEX.md**](./MASTER-INDEX.md) for the complete catalog of all 25 repositories.

---

## 🚀 Quick Start

### Clone and Setup

```bash
# Clone the root workspace
git clone https://github.com/Turbo-the-tech-dev/root.git
cd root

# View repository index
cat MASTER-INDEX.md

# Check available scripts
ls scripts/
```

### Deploy All Repositories

```bash
# Push all local repositories to GitHub
./push_all_repos.sh

# Clean up local copies (after successful push)
./cleanup_local_repos.sh
```

### Navigate the Workspace

```bash
# View project documentation
cat CLAUDE.md          # Development guidance
cat HOLOCRON.md        # Daily priorities & aliases
cat MASTER-INDEX.md    # Complete repo catalog

# Search across repositories
bash scripts/sector-search.sh <pattern>
```

---

## 🗂️ Directory Structure

```
root/
├── 📄 MASTER-INDEX.md           # Complete catalog of 25 repositories
├── 📄 CLAUDE.md                 # Development guidance & architecture
├── 📄 HOLOCRON.md               # Daily priorities, aliases, metrics
├── 📄 CONTRIBUTING.md           # Contribution guidelines
├── 📄 CODE_OF_CONDUCT.md        # Community standards
├── 📄 SECURITY.md               # Security policy
├── 📄 LICENSE                   # MIT License
│
├── 🔧 scripts/                  # Automation & utility scripts
│   ├── imperial-aliases.sh      # Shell aliases
│   ├── sector-search.sh         # Cross-repo search
│   └── README.md                # Script documentation
│
├── ⚡ Electrical-Core-API/      # .NET Core electrical calculations API
├── 🤖 agents/                   # AI agent configurations
├── 🐳 docker-compose.yml        # Service orchestration
│
├── 📁 DEATHSTAR/                # Bash CLI automation suite
├── 📁 Electrician-PROMPT-GENIE/ # Electrical prompt tools
├── 📁 Sector-15-Vader-Dev/      # Active development workspace
├── 📁 Sector-18-Turbo-Dev/      # Active development workspace
├── 📁 sectors/                  # Sector-based organization
│
├── 📁 .github/                  # GitHub Actions, templates, configs
├── 📁 .gitops/                  # GitOps configurations
├── 📁 k8s/                      # Kubernetes manifests
├── 📁 monitoring/               # Monitoring & observability
│
└── 📁 special_drive/            # Organized content (via sync)
    ├── 01_CRITICAL/             # Critical notes & strategy
    ├── 02_PROJECTS/             # Project files
    ├── 06_ELECTRICAL/           # Electrical engineering
    └── 07_ARCHIVE/              # Archived content
```

---

## 🛠️ Key Tools & Scripts

### Deployment Scripts

| Script | Purpose |
|--------|---------|
| `push_all_repos.sh` | Deploy all 25 repositories to GitHub |
| `cleanup_local_repos.sh` | Remove local copies after deployment |

### Automation Scripts

| Script | Purpose |
|--------|---------|
| `scripts/imperial-aliases.sh` | Load Dark-Key shell aliases |
| `scripts/sector-search.sh` | Search across all repositories |
| `scripts/gemini-regenerate.sh` | AI-powered regeneration (docs, tests, PR descriptions) |

### Gemini AI Integration

Regenerate documentation, tests, and more using Google's Gemini AI:

```bash
# Set API key (get from https://makersuite.google.com/app/apikey)
export GEMINI_API_KEY='your-api-key-here'

# Regenerate documentation for a project
./scripts/gemini-regenerate.sh --type docs --scope Electrical-Core-API

# Generate tests for existing code
./scripts/gemini-regenerate.sh --type tests --scope DEATHSTAR

# Generate commit message from staged changes
./scripts/gemini-regenerate.sh --type commit-msg

# Generate PR description
./scripts/gemini-regenerate.sh --type pr-description

# Code review with AI
./scripts/gemini-regenerate.sh --type code-review --scope scripts/

# Dry-run: preview without writing
./scripts/gemini-regenerate.sh --type docs --scope scripts/ --dry-run
```

GitHub Actions workflow (`.github/workflows/gemini-regenerate.yml`) auto-generates PR descriptions on pull requests.

### Dark-Key Aliases

After sourcing `scripts/imperial-aliases.sh`:

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

## 📦 Sub-Project Development

### React Native (Electrician)

```bash
cd Electrician-PROMPT-GENIE
npm install && npm test
```

### Flutter (sovereign-circuit-academy)

```bash
cd sovereign-circuit-academy/vader-academy-app
flutter pub get && flutter run
```

### Python Tools

```bash
python3 sovereign-circuit-academy/box_fill_calculator.py
```

### .NET Core API

```bash
cd Electrical-Core-API
dotnet run
```

### Bash CLI (DEATHSTAR)

```bash
cd DEATHSTAR
./deathstar.sh --help
```

---

## 🔐 Security

- **Secret Scanning:** Automated via GitHub Actions (`.github/workflows/secret-scan.yml`)
- **Dependency Alerts:** Enabled for npm, pip, and NuGet packages
- **Sensitive Data:** Never commit API keys, credentials, or secrets
- **Environment Variables:** Use `.env` files and reference `SECRETS_GUIDE.md`

Report vulnerabilities via [Security Policy](./SECURITY.md).

---

## 🤖 Automation & CI/CD

### GitHub Actions Workflows

| Workflow | Schedule | Purpose |
|----------|----------|---------|
| `monthly-report.yml` | 1st of month | Fleet-wide status report |
| `weekly-metrics.yml` | Weekly | Repository metrics tracking |
| `secret-scan.yml` | On push | Security scanning |
| `gemini-*.yml` | Various | Gemini AI integrations |

### Neuro-Symbolic Pipeline

The `agents/theoggrant/` directory contains the neuro-symbolic CI/CD blueprint:
- **LLM as Creative Engine** for code generation
- **Z3 SMT Solver** as Logical Auditor for formal verification
- **Feedback loop** for automated repair

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

---

## 📊 Repository Metrics

| Metric | Value |
|--------|-------|
| **Total Repositories** | 25 |
| **Deployed to GitHub** | 25 ✅ |
| **Active Development** | 1 (sovereign-circuit-academy) |
| **Automation Level** | Optimal |
| **Platform** | Termux (Android) |

---

## 🗺️ Roadmap

### Q1 2026
- [ ] Complete NEC 2026 compliance updates
- [ ] Expand electrical calculation API endpoints
- [ ] Refine neuro-symbolic pipeline integration

### Q2 2026
- [ ] Launch sovereign-circuit-academy mobile app
- [ ] Add interactive conduit bending visualizations
- [ ] Implement automated repository health checks

### Future
- [ ] Expand AI/ML educational content
- [ ] Add more Termux-optimized automation scripts
- [ ] Create template repository for new projects

---

## 📞 Support & Contribution

- **Issues:** Use [GitHub issue templates](.github/ISSUE_TEMPLATE/)
- **Discussions:** https://github.com/Turbo-the-tech-dev/root/discussions
- **Contributing:** See [CONTRIBUTING.md](./CONTRIBUTING.md)
- **Code of Conduct:** See [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md)

---

## 🔗 Quick Links

| Resource | URL |
|----------|-----|
| **GitHub Profile** | https://github.com/Turbo-the-tech-dev |
| **Master Index** | [MASTER-INDEX.md](./MASTER-INDEX.md) |
| **Holocron** | [HOLOCRON.md](./HOLOCRON.md) |
| **CLAUDE Guidance** | [CLAUDE.md](./CLAUDE.md) |
| **Security Policy** | [SECURITY.md](./SECURITY.md) |

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](./LICENSE) file for details.

---

*"Consolidated archive of all educational, AI/ML, and technical repositories."*
