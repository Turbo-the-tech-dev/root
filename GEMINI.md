# GEMINI.md

## Project Overview
**Turbo Fleet** is a high-performance orchestration hub managed by [@Turbo-the-tech-dev](https://github.com/Turbo-the-tech-dev). It is a **Turborepo monorepo** designed for Electrical Engineering education (NEC 2026 compliance), AI Prompt Engineering, and specialized developer utilities. The project integrates mobile applications (Flutter, Expo), AI logic templates, and extensive DevOps automation.

### Core Domains
- **Electrical Engineering:** NEC 2026 compliance, conduit bending, load calculations, and field reference tools.
- **AI/ML:** Advanced prompt engineering (CoT, few-shot), LLM fundamentals, and diagnostic workflow templates.
- **Developer Utilities:** Bash CLI suites (DEATHSTAR), build telemetry, and cross-sector automation (Imperial Monitoring).
- **Education:** Math fundamentals and college bridge resources.

---

## Architecture & Technology Stack
- **Orchestration:** [Turborepo](https://turbo.build/) with `npm workspaces`.
- **Frontend/Mobile:** 
    - **Flutter (Dart):** `sectors/17-flutter` (NEC Interview Prep).
    - **Expo/React Native:** `sectors/19-expo` (Field Ops).
    - **React:** `Electrician-PROMPT-GENIE` (AI Templates).
- **Backend/CLI:** 
    - **Node.js/TypeScript:** `DEATHSTAR`, `Electrician-PROMPT-GENIE`.
    - **Python:** `sectors/06-firestore`, `sectors/08-aws` (Automation scripts).
    - **Bash:** Root-level scripts and `DEATHSTAR` suite.
- **DevOps:**
    - **Cloud:** AWS (Terraform).
    - **Orchestration:** Kubernetes (K8s manifests in `k8s/`).
    - **CI/CD:** GitHub Actions (workflows in `.github/workflows/`).
    - **Monitoring:** Prometheus, Grafana, Alertmanager.

---

## Building and Running

### Root Workspace Commands
```bash
npm install        # Install all dependencies across all workspaces
npm run build      # Build all sectors via Turborepo
npm run test       # Run all unit tests across the fleet
npm run lint       # Run static analysis/type checking
```

### Specific Workspace Commands
| Workspace | Command | Purpose |
|-----------|---------|---------|
| **DEATHSTAR** | `npm test` | Run TSX-based scoring tests |
| **PROMPT-GENIE** | `npm test` | Run AI template validation tests |
| **Flutter App** | `flutter pub get && flutter test` | Manage Dart deps and test |
| **Expo App** | `npx expo start` | Start React Native dev server |

### DevOps & Infrastructure
- **Terraform:** `make tf-plan` / `make tf-apply` (targets `sectors/08-aws/infrastructure`).
- **Docker:** `docker-compose up -d` for local service orchestration.
- **Deployment:** Managed via `IMPERIAL_PUSH.md` and automated GitHub Actions.

---

## Development Conventions

### General Guidelines
- **Conventional Commits:** Use prefixes like `feat:`, `fix:`, `docs:`, `chore:`.
- **Safety-First Protocol:** All electrical logic must prioritize OSHA and LOTO (Lockout/Tagout) procedures.
- **Journeyman Mentor Tone:** Technical explanations should be practical and veteran-styled.
- **Environment:** Primarily developed on **Termux (Android)**. Avoid assumptions about native build toolchains (Xcode/Android Studio) unless explicitly targeting CI.

### Code Style
- **TypeScript:** Use `tsx` for running scripts and tests without a separate build step where possible.
- **Flutter:** Feature-first architecture under `lib/src/`. Uses `Riverpod` for state management.
- **React Native:** Three-layer pattern for calculators; utility functions must be pure.

### Imperial Monitoring (Sectors)
Automation is categorized into "Sectors":
- **Sector 02 (Gemini):** AI logic and linguistic telemetry.
- **Sector 08 (AWS):** Infrastructure and terminal history extraction.
- **Sector 18 (Turbo Dev):** Build and deployment telemetry.

---

## Key Files & Directories
- `MASTER-INDEX.md`: Full catalog of 25+ repositories in the ecosystem.
- `DEVOPS.md`: Comprehensive runbook for infrastructure and deployment.
- `CLAUDE.md`: Guidance for AI-assisted development workflows.
- `k8s/`: Kubernetes manifests for staging and production overlays.
- `sectors/`: Specialized sub-projects and automation scripts.

---
*Status: 151% OPERATIONAL | Last Updated: 2026-02-28*
