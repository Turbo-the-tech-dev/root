# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

This is the **root workspace repository** (`Turbo-the-tech-dev/root` on GitHub). It serves as:

1. An **npm/Turbopack monorepo** with two active TypeScript workspaces (`DEATHSTAR`, `Electrician-PROMPT-GENIE`)
2. An **orchestration hub** tracking and deploying 25+ sub-repositories across GitHub
3. A **GitOps control plane** with Kubernetes manifests, Terraform infrastructure, and ArgoCD configuration for the Electrician app

**GitHub Organization:** [@Turbo-the-tech-dev](https://github.com/Turbo-the-tech-dev)
**Primary Branch:** `main` (active development) / `27-claude` (feature branch)
**Platform:** Termux (Android) — no native Xcode/Android Studio build toolchain

---

## Repository Structure

```
root/
├── CLAUDE.md                        # This file — AI assistant guidance
├── MASTER-INDEX.md                  # Catalog of all 25 GitHub repositories
├── README.md                        # Public-facing project overview
├── DEVOPS.md                        # DevOps runbook (quick reference)
├── DEPLOYMENT_CHECKLIST.md          # Pre-deployment and post-deployment checklist
├── GITOPS_QUICKSTART.md             # GitOps onboarding guide
├── HOLOCRON.md                      # Daily priorities, aliases, metrics
├── CONTRIBUTING.md                  # Contribution guidelines
├── CODE_OF_CONDUCT.md               # Community standards
├── SECURITY.md                      # Security policy
├── CHANGELOG_SESSION.md             # Session changelog
├── BANNER.md                        # Project banner/branding
├── QWEN.md                          # Qwen AI integration notes
│
├── package.json                     # Root workspace config (Turbo + npm workspaces)
├── turbo.json                       # Turborepo task pipeline config
├── Makefile                         # Common dev/infra commands (see below)
├── docker-compose.yml               # Local service orchestration
│
├── DEATHSTAR/                       # Workspace: TypeScript scoring engine
│   ├── scoring.ts                   # calculateScore() — keyword-match scoring
│   ├── scoring.test.ts              # Test suite
│   ├── tsconfig.json
│   └── package.json
│
├── Electrician-PROMPT-GENIE/        # Workspace: Electrical prompt library
│   ├── types.ts                     # PromptTemplate, Question, Framework types
│   ├── constants.tsx                # Prompt templates, frameworks, questions
│   ├── validation.ts                # Input validation logic
│   ├── constants.test.tsx           # Tests for constants
│   ├── validation.test.ts           # Tests for validation
│   ├── templates/                   # Structured prompt templates
│   ├── chains/                      # LLM chain definitions (NEC)
│   └── advanced/                    # Advanced prompt strategies
│
├── sectors/                         # Sector-based project organization
│   ├── 02-gemini/                   # Gemini AI integration scripts
│   ├── 06-firestore/                # Firebase/Firestore update scripts
│   ├── 07-termux/                   # Termux nightly sync
│   ├── 08-aws/                      # AWS infrastructure (Terraform + scripts)
│   │   └── infrastructure/          # main.tf — S3, CloudFront, ACM, IAM, Route53
│   ├── 09-security/                 # Bug bounty & security scripts
│   ├── 17-flutter/                  # Flutter web app (sovereign-circuit-academy)
│   ├── 19-expo/                     # Expo/React Native config
│   └── 20-mainframe-migration/      # Mainframe migration planning docs
│
├── k8s/                             # Kubernetes manifests (Kustomize)
│   ├── base/                        # Base resources (Deployment, HPA, NetworkPolicy, PDB)
│   └── overlays/                    # Environment overlays
│       ├── staging/
│       └── production/              # Canary deployment config
│
├── .gitops/                         # GitOps (ArgoCD)
│   ├── app-of-apps/turbo-fleet.yaml # ArgoCD ApplicationSet
│   └── applications/               # Environment-specific ArgoCD apps
│
├── monitoring/                      # Prometheus/Grafana stack values
│
├── scripts/                         # Utility scripts
│   ├── imperial-aliases.sh          # Shell aliases (load with: source scripts/imperial-aliases.sh)
│   ├── sector-search.sh             # Cross-repo search tool
│   └── gemini-regenerate.sh         # AI-powered doc/test regeneration
│
├── Sector-15-Vader-Dev/             # Vader dev workspace scripts
├── Sector-18-Turbo-Dev/             # Turbo dev workspace scripts
├── epic/root/AGENTS.md              # AI agent configuration
└── .github/
    ├── workflows/                   # GitHub Actions CI/CD pipelines
    ├── ISSUE_TEMPLATE/              # Bug reports, features, tasks
    ├── SECRETS_GUIDE.md             # How to configure required secrets
    └── SECURITY_CHECKLIST.md        # Security review checklist
```

---

## Active Workspaces (npm/Turbo)

This repo is an **npm workspaces monorepo** powered by **Turborepo**. Two workspaces are active:

### 1. DEATHSTAR (TypeScript)
- **Purpose:** Keyword-match scoring engine for interview transcription analysis
- **Key file:** `DEATHSTAR/scoring.ts` — exports `calculateScore(transcription, keywords): number`
- **Test:** `cd DEATHSTAR && npm test` (uses `tsx --test`)
- **Lint:** `cd DEATHSTAR && npm run lint` (TypeScript type-check only via `tsc --noEmit`)

### 2. Electrician-PROMPT-GENIE (TypeScript + React types)
- **Purpose:** Prompt library and quiz engine for electrical interview prep / NEC 2026 compliance
- **Key types (`types.ts`):**
  - `PromptTemplate` — AI prompt with title, content, category, stars
  - `Question` — Multiple-choice quiz question with NEC reference
  - `Framework` — Reasoning strategy injected as system prompt
- **Test:** `cd Electrician-PROMPT-GENIE && npm test`
- **Coverage:** `npm run test:coverage`

### Running All Workspaces

```bash
# Install all workspace dependencies
npm install --workspaces
# or
make install

# Run all tests (via Turbo)
npm test
# or
make test

# Lint all workspaces
npm run lint
# or
make lint

# Build all workspaces
npm run build
# or
make build
```

---

## Makefile Commands

The `Makefile` is the primary developer interface. Run `make help` to see all targets.

### Development
```bash
make install          # Install all workspace dependencies
make test             # Run all tests
make lint             # Run linters
make build            # Build all workspaces
make clean            # Remove node_modules/dist/build/coverage dirs
make ci-local         # Full local CI simulation (lint → test → build → docker → tf-validate)
make pr-check         # Alias for ci-local
```

### Docker
```bash
make docker-build     # Build Docker images for DEATHSTAR and Electrician-PROMPT-GENIE
make docker-run       # docker-compose up -d
make docker-clean     # Remove all turbo-fleet containers and images
```

### Infrastructure (Terraform — AWS)
```bash
make tf-init          # terraform init (backend: S3 + DynamoDB)
make tf-plan          # terraform plan (outputs tfplan)
make tf-apply         # terraform apply tfplan
make tf-validate      # terraform fmt-check + validate
make tf-destroy       # Destroy (requires typing 'destroy' to confirm)
# ENV=production make tf-plan  — use production tfvars
```

### Kubernetes
```bash
make k8s-apply-staging     # kubectl apply -k k8s/overlays/staging
make k8s-apply-production  # kubectl apply -k k8s/overlays/production (confirm required)
make k8s-pods              # List pods in staging + production
make k8s-logs              # Tail electrician logs in staging
```

### ArgoCD
```bash
make argocd-sync-staging     # Sync staging app
make argocd-sync-production  # Sync production app
make argocd-status           # Show all app status
make argocd-health           # Wait for apps to become healthy
```

---

## CI/CD Pipeline (GitHub Actions)

**Main pipeline:** `.github/workflows/ci-cd.yml`

| Stage | Jobs | Trigger |
|-------|------|---------|
| 1. Validate | Discover workspaces, validate Terraform | All pushes/PRs |
| 2. Test (parallel) | `test-electrician`, `test-deathstar` | After validate |
| 3. Security Scan | Trivy FS scan + npm audit | After validate |
| 4. Deploy Staging | Build → S3 → CloudFront invalidate | Push to `main` |
| 5. Deploy Production | Promote from staging | Manual `workflow_dispatch` |
| 6. Smoke Test | HTTP check against staging URL | After staging deploy |
| 7. Notify | Slack webhook notification | Always |

**Other active workflows:**

| Workflow | File | Schedule/Trigger |
|----------|------|-----------------|
| Deploy Electrician | `deploy-electrician.yml` | Push to main |
| EAS Build/Update | `eas-build-update.yml` | Manual |
| Canary Rollout | `canary-rollout.yml` | After staging |
| CodeQL Analysis | `codeql-analysis.yml` | Push/PR |
| Nightly Audit | `nightly-audit.yml` | Nightly |
| Link Checker | `link-checker.yml` | Scheduled |
| Gemini Regenerate | `gemini-regenerate.yml` | PRs / manual |
| Sovereign Gatekeeper | `sovereign-gatekeeper.yml` | PRs |

**Required GitHub Secrets** (see `.github/SECRETS_GUIDE.md`):

| Secret | Description |
|--------|-------------|
| `AWS_ROLE_ARN` | IAM role ARN for OIDC (no long-lived credentials) |
| `SLACK_WEBHOOK_URL` | Slack notifications (optional) |
| `KUBECONFIG` | Base64-encoded kubeconfig |
| `S3_BUCKET_NAME` | Per-environment (staging/production) |
| `CLOUDFRONT_DISTRIBUTION_ID` | Per-environment |

---

## AWS Infrastructure (Terraform)

**Location:** `sectors/08-aws/infrastructure/`
**Backend:** S3 bucket `turbo-fleet-terraform-state` + DynamoDB locking (region: `us-east-1`)
**Terraform version:** >= 1.6.0, AWS provider ~> 5.0

**Resources provisioned:**
- S3 buckets: static assets, build artifacts (30-day lifecycle), access logs (90-day lifecycle)
- CloudFront distribution with OAI, HTTPS-only, SPA error handling (404→200/index.html)
- ACM certificate + Route53 records (if custom domain configured)
- IAM role for GitHub Actions OIDC (no static credentials)

**Environments:** `staging` (default) and `production` (destruction protection enabled)

**Deploy:**
```bash
./sectors/08-aws/imperial-arsenal.sh staging     # Deploy staging
./sectors/08-aws/imperial-arsenal.sh production  # Deploy production
./sectors/08-aws/imperial-purge.sh staging       # Destroy staging only
```

---

## Kubernetes & GitOps (ArgoCD)

**K8s manifests:** `k8s/` (Kustomize)
**GitOps config:** `.gitops/`

**Electrician deployment:**
- 3 replicas, RollingUpdate strategy
- Non-root security context, read-only root filesystem
- Resource limits: 500m CPU / 512Mi memory
- Probes: `/healthz` (liveness), `/readyz` (readiness)
- TopologySpreadConstraints for high availability

**ArgoCD ApplicationSet** (`.gitops/app-of-apps/turbo-fleet.yaml`):
- `electrician-staging`: auto-sync enabled, auto-heal
- `electrician-production`: auto-sync disabled (manual approval required)

**Canary rollouts:** `k8s/overlays/production/canary-deployment.yaml`

---

## Scripts & Utilities

### Shell Aliases (`scripts/imperial-aliases.sh`)

Source this to get shorthand navigation:
```bash
source scripts/imperial-aliases.sh

h      # Open HOLOCRON.md
t      # Today's priorities
s      # System status
e      # Electrical portal
s08    # Jump to AWS sector (sectors/08-aws)
s17    # Jump to Flutter sector (sectors/17-flutter)
s19    # Jump to Expo sector (sectors/19-expo)
```

### Sector Search (`scripts/sector-search.sh`)

```bash
bash scripts/sector-search.sh <query>     # Search MASTER-INDEX by keyword
bash scripts/sector-search.sh 17          # Find Flutter sector
bash scripts/sector-search.sh AWS -j      # Find + jump to AWS sector
bash scripts/sector-search.sh 06 -v       # Search + Vader-Gate secret scan
bash scripts/sector-search.sh -b          # Benchmark (target: <10ms)
```

### Gemini AI Regeneration (`scripts/gemini-regenerate.sh`)

```bash
export GEMINI_API_KEY='your-api-key-here'
./scripts/gemini-regenerate.sh --type docs --scope Electrician-PROMPT-GENIE
./scripts/gemini-regenerate.sh --type tests --scope DEATHSTAR
./scripts/gemini-regenerate.sh --type commit-msg
./scripts/gemini-regenerate.sh --type pr-description
./scripts/gemini-regenerate.sh --type code-review --scope scripts/
./scripts/gemini-regenerate.sh --type docs --scope scripts/ --dry-run
```

---

## Key Projects (25 Sub-Repositories)

All deployed to [@Turbo-the-tech-dev](https://github.com/Turbo-the-tech-dev). See `MASTER-INDEX.md` for full catalog.

| Category | Count | Examples |
|----------|-------|---------|
| Educational | 7 | college-bridge, viral-math-problems, visual-math |
| AI/ML | 8 | llm-fundamentals, advanced-prompt-engineering, generative-ai |
| Electrical | 2 | electrical-field, sovereign-circuit-academy |
| Math | 3 | mathematicians, concrete-mathematics |
| Special Projects | 5 | julia-programming, masters-of-reverse-engineering, root |

**Most actively developed:**
- `sovereign-circuit-academy` — Flutter app for NEC 2026, conduit bending, load calculators (Riverpod)
- `Electrician-PROMPT-GENIE` — TypeScript prompt library (in this repo)
- `DEATHSTAR` — TypeScript scoring engine (in this repo)

---

## Development Conventions

### Commit Messages (Conventional Commits)

```
type(scope): brief message

Longer explanation if needed.
```

| Type | Use for |
|------|---------|
| `feat:` | New features |
| `fix:` | Bug fixes |
| `docs:` | Documentation changes |
| `refactor:` | Code refactoring |
| `chore:` | Build, CI, dependency updates |
| `test:` | Test additions or fixes |

**Examples:**
```
feat(scoring): add weighted keyword scoring mode
fix(validation): handle undefined necReference gracefully
docs(claude): update infrastructure and workflow sections
```

### Branch Naming

```
feature/short-description
fix/short-description
docs/short-description
refactor/short-description
chore/short-description
claude/<task-description>-<session-id>    # Claude AI branches
```

### TypeScript/JavaScript

- ESLint + Prettier (2-space indent)
- Prefer `const` over `let`
- Add JSDoc comments for exported functions and interfaces
- Type-check only with `tsc --noEmit` (no separate build step for workspaces)
- Tests use Node.js built-in test runner via `tsx --test`

### Bash Scripts

```bash
#!/usr/bin/env bash
set -euo pipefail
# 2-space indentation
# Quote all variables: "${var}"
# Use readonly for constants
# snake_case for functions
```

### Terraform

- All resources defined in code (no ClickOps)
- Use `terraform.tfvars` per environment
- Destruction protection enabled for production
- IAM roles use OIDC (no long-lived credentials)

---

## Security Practices

- **No secrets in code or Docker images** — Use GitHub Secrets, AWS Secrets Manager, External Secrets Operator
- **No `.env` files committed** — Reference `.github/ENVIRONMENT_VARIABLES.example`
- **Trivy scanning** on every PR (blocks CRITICAL/HIGH)
- **CodeQL** analysis for JavaScript/TypeScript
- **Vader-Gate** secret scanning: `bash scripts/sector-search.sh <sector> -v`
- **Container hardening:** non-root user, read-only filesystem, dropped capabilities
- **S3:** public access blocked, server-side encryption (AES256), versioning enabled
- **CloudFront:** HTTPS-only, Origin Access Identity

Report vulnerabilities via `SECURITY.md`.

---

## Local Development

### Prerequisites

- Node.js 20+, npm
- Docker + docker-compose
- Terraform >= 1.6.0 (for infrastructure work)
- kubectl + argocd CLI (for Kubernetes work)

### Quick Start

```bash
# 1. Install dependencies
npm install

# 2. Run tests
npm test

# 3. Start local services (Docker)
docker-compose up -d

# 4. View logs
docker-compose logs -f
```

### Workspace Ports (Docker)

| Workspace | Port |
|-----------|------|
| Electrician-PROMPT-GENIE | 3001 |
| DEATHSTAR | 3002 |

### Working with Sub-Projects

Each major sub-project is an independent git repository. Always `cd` into it before running git commands:

```bash
# Flutter (sovereign-circuit-academy)
cd sovereign-circuit-academy/vader-academy-app
flutter pub get && flutter run

# Python tools (electrical calculators)
python3 sovereign-circuit-academy/box_fill_calculator.py

# Expo/React Native
cd sectors/19-expo
npx expo start
```

---

## Troubleshooting

### Terraform init fails
```bash
rm -rf sectors/08-aws/infrastructure/.terraform
make tf-init
```

### Docker build fails
```bash
make clean
docker builder prune -f
make docker-build
```

### GitHub Actions OIDC fails
1. Verify IAM role trust policy allows `token.actions.githubusercontent.com`
2. Check `aud` claim is `sts.amazonaws.com`
3. Check `sub` claim matches `repo:Turbo-the-tech-dev/root:*`

### Tests failing
```bash
# Run single workspace tests with verbose output
cd DEATHSTAR && npm test -- --reporter=spec
cd Electrician-PROMPT-GENIE && npm run test:watch
```

---

## Reference Documents

| Document | Purpose |
|----------|---------|
| `MASTER-INDEX.md` | Complete catalog of all 25 repositories |
| `DEVOPS.md` | DevOps runbook with quick-reference command table |
| `DEPLOYMENT_CHECKLIST.md` | Pre/post-deployment verification checklist |
| `GITOPS_QUICKSTART.md` | ArgoCD + GitOps onboarding |
| `HOLOCRON.md` | Daily priorities, aliases, metrics |
| `.github/SECRETS_GUIDE.md` | Configure GitHub Secrets and environments |
| `.github/SECURITY_CHECKLIST.md` | Security review checklist |
| `scripts/README.md` | Sector search and alias documentation |
