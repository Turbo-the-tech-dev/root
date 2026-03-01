# QWEN.md — Root Workspace Context

**Workspace:** Turbo-the-tech-dev/root Orchestration
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
root/
├── MASTER-INDEX.md              # Complete repo catalog
├── CLAUDE.md                    # Claude Code guidance
├── HOLOCRON.md                  # Master command center (priorities, aliases)
├── docker-compose.yml           # Service orchestration
├── Makefile                     # Build & deployment commands
├── push_all_repos.sh            # Deploy all repos to GitHub
├── cleanup_local_repos.sh       # Post-deploy cleanup
│
├── scripts/                     # Automation suite
│   ├── imperial-aliases.sh      # Shell aliases
│   ├── sector-search.sh         # Cross-repo search
│   └── README.md                # Script documentation
│
├── DEATHSTAR/                   # Bash CLI tools
├── Electrician-PROMPT-GENIE/    # React Native electrical tools
├── Sector-15-Vader-Dev/         # Active development workspace
├── Sector-18-Turbo-Dev/         # Active development workspace
├── sectors/                     # Sector-based organization (01-20)
│
├── Electrical-Core-API/         # .NET Core API service
├── agents/                      # AI agent configurations
├── k8s/                         # Kubernetes manifests
├── monitoring/                  # Monitoring & observability
│
├── .github/                     # GitHub Actions, templates, configs
│   ├── workflows/               # CI/CD pipelines
│   └── ISSUE_TEMPLATE/          # Bug, feature, task templates
│
└── .gitops/                     # GitOps configurations
```

---

## 🚀 Building and Running

### Deploy and Manage Repositories

```bash
# Push all local repositories to GitHub
./push_all_repos.sh

# Clean up local repository copies (after successful push)
./cleanup_local_repos.sh

# Verify repository status
cat MASTER-INDEX.md
```

### Makefile Commands

```bash
make help             # Show all available commands
make install          # Install workspace dependencies (npm)
make test             # Run all tests
make lint             # Run all linters
make build            # Build all workspaces
make clean            # Clean build artifacts

# Docker
make docker-build     # Build Docker images
make docker-run       # Run containers via docker-compose
make docker-clean     # Remove containers

# Terraform (Infrastructure)
make tf-init          # Initialize Terraform
make tf-plan          # Show Terraform plan
make tf-apply         # Apply Terraform changes
make tf-destroy       # Destroy infrastructure
make tf-validate      # Validate Terraform config

# Kubernetes
make k8s-apply-staging      # Apply staging config
make k8s-apply-production   # Apply production config
make k8s-diff-staging       # Show staging diff
make k8s-pods               # List pods

# ArgoCD
make argocd-sync-staging    # Sync staging
make argocd-sync-production # Sync production
make argocd-status          # Show app status
```

### npm/Turbo Commands

```bash
npm run build         # Build all workspaces (Turbo)
npm run lint          # Lint all workspaces
npm run test          # Test all workspaces
npm run deploy        # Deploy all workspaces
npm install --workspaces  # Install all dependencies
```

### Docker Services

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Sub-Project Development

```bash
# React Native (Electrician)
cd Electrician-PROMPT-GENIE
npm install && npm test

# Flutter (sovereign-circuit-academy)
cd sovereign-circuit-academy/vader-academy-app
flutter pub get && flutter run

# Python tools
python3 sovereign-circuit-academy/box_fill_calculator.py

# .NET Core API
cd Electrical-Core-API
dotnet run

# Bash CLI (DEATHSTAR)
cd DEATHSTAR
./deathstar.sh --help
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

### TypeScript/JavaScript

- Use ESLint configuration from project
- Format with Prettier (2-space indent)
- Prefer `const` over `let`
- Add JSDoc comments for exported functions

### Markdown

- Use `#` for headings (not underlines)
- Keep line length under 100 characters
- Use backticks for code references

---

## 🔐 Security

### Reporting Vulnerabilities

- **Email:** security@turbo-the-tech-dev.com
- **GitHub:** Use private vulnerability reporting (Security tab)
- **Response Time:** Within 48 hours
- **Do NOT** open public issues for security vulnerabilities

### Required Secrets (GitHub Actions)

Configure in **Settings → Secrets and variables → Actions**:

| Secret | Description |
|--------|-------------|
| `AWS_ROLE_ARN` | IAM role ARN for OIDC authentication |
| `SLACK_WEBHOOK_URL` | Slack incoming webhook |
| `KUBECONFIG` | Kubernetes config (base64 encoded) |

See `.github/SECRETS_GUIDE.md` for complete setup instructions.

### Environment Variables

See `.github/ENVIRONMENT_VARIABLES.example` for required variables:
- `S3_BUCKET_NAME`
- `CLOUDFRONT_DISTRIBUTION_ID`
- `DEPLOY_URL`

### Security Best Practices

- Never commit secrets or API keys
- Use `.env` files for sensitive configuration
- Review shell scripts before running with elevated privileges
- All scripts use `set -euo pipefail` for safe execution
- Automated secret scanning via GitHub Actions

---

## 🤖 Automation & CI/CD

### GitHub Actions Workflows

| Workflow | Schedule | Purpose |
|----------|----------|---------|
| `ci-cd.yml` | On push | Main CI/CD pipeline |
| `deploy-electrician.yml` | On push | Deploy Electrician app |
| `eas-build-update.yml` | On push | EAS build updates |
| `link-checker.yml` | Scheduled | Check broken links |
| `main.yml` | On push | Main branch workflow |
| `nightly-audit.yml` | Nightly | Security audit |
| `terraform-plan.yml` | On push | Terraform planning |
| `terraform-apply.yml` | On merge | Terraform apply |
| `sovereign-gatekeeper.yml` | On push | Security gatekeeping |

### Neuro-Symbolic Pipeline

The `agents/theoggrant/` directory contains the neuro-symbolic CI/CD blueprint:
- **LLM as Creative Engine** for code generation
- **Z3 SMT Solver** as Logical Auditor for formal verification
- **Feedback loop** for automated repair

---

## 🧭 Quick Navigation (Dark-Key Aliases)

Source `scripts/imperial-aliases.sh` for these shortcuts:

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

### Sector Navigation

```bash
s 08    # AWS sector
s 17    # Flutter sector
s 19    # Expo sector
s 06    # Firestore sector
s 15    # Vader (Security) sector
```

---

## 📊 Repository Metrics

| Metric | Value |
|--------|-------|
| **Total Repositories** | 25 |
| **Deployed to GitHub** | 25 ✅ |
| **Active Development** | sovereign-circuit-academy |
| **Automation Level** | Optimal |
| **Platform** | Termux (Android) |

---

## 🔗 Key Files Reference

| File | Purpose |
|------|---------|
| `MASTER-INDEX.md` | Catalog of all 25 GitHub repositories |
| `CLAUDE.md` | Project guidance for Claude Code |
| `HOLOCRON.md` | Daily priorities, navigation aliases, metrics |
| `CONTRIBUTING.md` | Contribution guidelines |
| `CODE_OF_CONDUCT.md` | Community standards |
| `SECURITY.md` | Security policy and vulnerability reporting |
| `Makefile` | Build, test, deploy commands |
| `docker-compose.yml` | Service orchestration |
| `.github/workflows/` | GitHub Actions CI/CD pipelines |

---

## 📞 Support

- **Issues:** Use GitHub issue templates (`.github/ISSUE_TEMPLATE/`)
- **Discussions:** https://github.com/Turbo-the-tech-dev/root/discussions
- **Security:** security@turbo-the-tech-dev.com

---

**Status:** Active | **Last Updated:** 2026-02-28
