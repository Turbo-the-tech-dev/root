# Turbo Fleet Root — Project Context

> **Imperial Fleet Command Center** — Electrical engineering education, NEC compliance tools, AI/ML resources, and DevOps infrastructure.

---

## 🏛️ Project Overview

**Turbo Fleet Root** is a monorepo workspace serving as the orchestration hub for 25+ repositories spanning electrical engineering, AI/ML, and developer tools. This is the central command center for the Turbo-the-tech-dev organization.

### Primary Functions

1. **Workspace Orchestration** — Turborepo-managed monorepo with npm workspaces
2. **NEC 2026 Compliance** — Electrical engineering education and compliance tools
3. **AI Prompt Engineering** — Specialized templates for electrician workflows
4. **DevOps Infrastructure** — Full CI/CD, Kubernetes, GitOps, and cloud deployment

### Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    GitHub Actions CI/CD                         │
│  Terraform → Build → Test → Deploy → Canary → Production        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      AWS Cloud                                  │
│  S3 (Static) ← CloudFront (CDN) ← ACM (SSL) ← Route53 (DNS)    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Kubernetes (EKS)                             │
│  ArgoCD (GitOps) + Prometheus/Grafana (Monitoring)              │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📁 Directory Structure

```
root/
├── .github/
│   └── workflows/           # 11 GitHub Actions workflows
│       ├── ci-cd.yml        # Main CI/CD pipeline
│       ├── terraform-*.yml  # Infrastructure plan/apply
│       ├── deploy-electrician.yml  # Flutter web deployment
│       ├── eas-build-update.yml    # Expo/EAS OTA updates
│       ├── canary-rollout.yml      # Progressive delivery
│       ├── nightly-audit.yml       # Drift detection, security
│       └── link-checker.yml        # Monthly broken link audit
│
├── .gitops/                 # ArgoCD configurations
│   ├── applications/        # Staging/Production apps
│   └── app-of-apps/         # ApplicationSet pattern
│
├── sectors/                 # Imperial Sector deployments
│   ├── 02-gemini/          # Linguistic telemetry
│   ├── 05-github/          # GraphQL bridge, PR telemetry
│   ├── 06-firestore/       # Firebase/Firestore integration
│   ├── 07-termux/          # Termux CLI utilities
│   ├── 08-aws/             # AWS Infrastructure (Terraform)
│   │   └── infrastructure/  # S3, CloudFront, IAM, ACM
│   ├── 17-flutter/         # Flutter interview prep app
│   ├── 18-turbo-dev/       # Turbo development
│   ├── 19-expo/            # React Native + EAS Build
│   └── 20-mainframe-migration/  # Legacy migration strategy
│
├── DEATHSTAR/              # Bash CLI tool suite, scoring
├── Electrician-PROMPT-GENIE/  # AI prompt templates
├── k8s/                    # Kubernetes manifests
│   ├── base/               # Base Kustomize configs
│   ├── overlays/           # Staging/Production overlays
│   └── external-secrets/   # AWS Secrets Manager integration
│
├── monitoring/             # Prometheus/Grafana stack
└── [Documentation Files]
```

---

## 🛠️ Technology Stack

### Core Technologies

| Category | Technology | Purpose |
|----------|------------|---------|
| **Monorepo** | Turborepo + npm workspaces | Workspace orchestration |
| **CI/CD** | GitHub Actions | Automated pipelines |
| **Infrastructure** | Terraform | AWS IaC (S3, CloudFront, IAM, ACM) |
| **Containers** | Docker + Compose | Multi-stage builds |
| **Orchestration** | Kubernetes + Kustomize | EKS deployment |
| **GitOps** | ArgoCD | Declarative deployments |
| **Monitoring** | Prometheus + Grafana + Alertmanager | Observability stack |
| **Frontend** | Flutter Web | Interview prep application |
| **Mobile** | Expo (React Native) | Field ops mobile app |
| **Backend** | Node.js + TypeScript | CLI utilities, scoring |

### Sector-Specific Stack

| Sector | Technology | Function |
|--------|------------|----------|
| **08-AWS** | Terraform, AWS SDK | Cloud infrastructure |
| **17-Flutter** | Flutter, Riverpod, GoRouter | Interview prep app |
| **19-Expo** | React Native, EAS Build | Mobile app + OTA updates |
| **20-Mainframe** | Migration strategy docs | Legacy modernization |

---

## 🚀 Quick Start

### Prerequisites

- Node.js 20+
- npm 10+
- Turborepo (`npm install -g turbo`)
- Docker (optional, for local testing)
- Terraform 1.7+ (for infrastructure)
- kubectl + ArgoCD CLI (for Kubernetes)

### Installation

```bash
# Install all workspace dependencies
npm install

# Or use the Makefile
make install
```

### Development Commands

```bash
# Build all workspaces
npm run build
make build

# Run tests
npm run test
make test

# Run linters
npm run lint
make lint

# Clean build artifacts
make clean
```

### Docker Operations

```bash
# Build Docker images for all workspaces
make docker-build

# Run containers locally
make docker-run

# Remove all containers
make docker-clean
```

---

## 🏗️ Infrastructure Operations

### Terraform Commands

```bash
# Initialize Terraform
make tf-init

# Preview changes
make tf-plan

# Apply changes
make tf-apply

# Validate configuration
make tf-validate

# Destroy infrastructure (DANGEROUS)
make tf-destroy ENV=staging
```

### Kubernetes Commands

```bash
# Show diff for staging
make k8s-diff-staging

# Apply staging configuration
make k8s-apply-staging

# List pods
make k8s-pods

# Tail logs
make k8s-logs
```

### ArgoCD Operations

```bash
# Sync staging application
make argocd-sync-staging

# Sync production application
make argocd-sync-production

# Check application status
make argocd-status

# Wait for health
make argocd-health
```

---

## 📦 CI/CD Pipelines

### Workflow Overview

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `ci-cd.yml` | Push/PR to main | Main pipeline: test, scan, build, deploy |
| `terraform-plan.yml` | PR to main | Preview infrastructure changes |
| `terraform-apply.yml` | Merge to main | Deploy infrastructure |
| `deploy-electrician.yml` | Push/Manual | Build & deploy Flutter web app |
| `eas-build-update.yml` | Push/Manual | Expo build + OTA updates |
| `canary-rollout.yml` | After deploy | Progressive delivery with analysis |
| `nightly-audit.yml` | 2 AM UTC daily | Drift detection, security scan |
| `link-checker.yml` | Monthly | Broken link detection |

### Environment Promotion

```
PR Opened → Tests + Security Scan → Merge to main
    ↓
Deploy to Staging (auto) → Canary Analysis → Production (manual approval)
```

---

## 📊 Workspaces

### DEATHSTAR

Bash CLI tool suite and transcription scoring utility.

```bash
cd DEATHSTAR
npm install
npm test
```

**Tech:** TypeScript, tsx, Node.js

### Electrician-PROMPT-GENIE

AI prompt templates for electrician workflows (NEC compliance, troubleshooting, load calculations).

```bash
cd Electrician-PROMPT-GENIE
npm install
npm test
```

**Tech:** React, TypeScript, tsx

### Sector 17 (Flutter)

NEC 2026 interview preparation application with Riverpod state management and GoRouter navigation.

```bash
cd sectors/17-flutter
flutter pub get
flutter test
flutter build web --release
```

**Tech:** Flutter, Riverpod, GoRouter, Equatable

### Sector 19 (Expo)

React Native field operations app with EAS Build and OTA updates.

```bash
cd sectors/19-expo
npm install
npx expo start
eas build --profile preview
eas update --branch production
```

**Tech:** React Native, Expo, EAS Build

---

## 🔐 Security & Secrets

### GitHub Secrets Required

| Secret | Scope | Purpose |
|--------|-------|---------|
| `AWS_ROLE_ARN` | Repository | OIDC authentication to AWS |
| `SLACK_WEBHOOK_URL` | Repository | Deployment notifications |
| `S3_BUCKET_NAME` | Environment (staging/prod) | Deployment target |
| `CLOUDFRONT_DISTRIBUTION_ID` | Environment | Cache invalidation |
| `EXPO_TOKEN` | Repository | EAS Build authentication |
| `KUBECONFIG` | Repository | Kubernetes cluster access |

### OIDC Trust Policy

GitHub Actions authenticates to AWS via OIDC (no long-lived credentials):

```json
{
  "Principal": {
    "Federated": "arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
  },
  "Condition": {
    "StringLike": {
      "token.actions.githubusercontent.com:sub": "repo:Turbo-the-tech-dev/root:*"
    }
  }
}
```

---

## 🧪 Development Conventions

### Code Style

- **TypeScript:** Strict mode enabled
- **Formatting:** Consistent indentation, trailing commas
- **Naming:** camelCase for variables/functions, PascalCase for types/classes

### Testing Practices

- Unit tests co-located with source files (`*.test.ts`)
- Test runner: `tsx --test`
- Coverage uploaded to GitHub Actions artifacts

### Commit Messages

Conventional Commits format:

```
feat(scope): description of new feature
fix(scope): bug fix description
docs(scope): documentation changes
refactor(scope): code refactoring
test(scope): test additions/updates
chore(scope): maintenance tasks
```

---

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Project overview and quick links |
| `DEVOPS.md` | DevOps runbook and troubleshooting |
| `DEPLOYMENT_CHECKLIST.md` | Marcus Hale's deployment checklist |
| `GITOPS_QUICKSTART.md` | ArgoCD setup guide |
| `IMPERIAL_PUSH.md` | 8-hour sprint runbook |
| `MASTER-INDEX.md` | Full repository catalog (25 repos) |
| `SECRETS_GUIDE.md` | GitHub Secrets configuration |
| `monthly-audit-response.md` | C-3PO audit findings and responses |

---

## 🆘 Troubleshooting

### Common Issues

**Terraform init fails:**
```bash
rm -rf sectors/08-aws/infrastructure/.terraform
make tf-init
```

**Docker build fails:**
```bash
make clean
docker builder prune -f
make docker-build
```

**GitHub Actions OIDC fails:**
1. Verify IAM role trust policy allows `token.actions.githubusercontent.com`
2. Check `aud` claim matches `sts.amazonaws.com`
3. Verify `sub` claim pattern matches your repo

**Flutter build fails:**
```bash
cd sectors/17-flutter
flutter clean
flutter pub get
flutter build web --release
```

---

## 📞 Key Personnel

| Role | Name | Approval Status |
|------|------|-----------------|
| Senior DevOps | Marcus Hale | ☕ Caffeinated |
| Mainframe Migration | Ray Cole | ✅ Approved |
| Master Turbo | Turbo-the-tech-dev | 👑 Sovereign |
| Audit Droid | C-3PO | 🤖 151% OPERATIONAL |

---

## 🎯 Current Sprint Status

**Imperial 8-Hour Sprint** — In Progress

| Milestone | Status | Notes |
|-----------|--------|-------|
| DevOps Infrastructure | ✅ Complete | 56 files, Terraform + K8s + ArgoCD |
| Flutter Scaffold | ✅ Complete | 15 files, Riverpod + GoRouter |
| Expo/EAS Pipeline | ✅ Complete | 6 files, OTA updates automated |
| Mainframe Migration | ✅ Phase 0 Ready | Discovery checklist delivered |
| refactored-sniffle Port | ⏳ Pending | Awaiting 20 quiz files |

---

*Last Updated: 2026-02-28*
*Repository Status: 151% OPERATIONAL*
*Marcus Hale approved — Infrastructure as Code complete.*
