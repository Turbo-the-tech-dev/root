                                                                               │
│  1 # GEMINI.md                                                                    │
│  2                                                                                │
│  3 ## Project Overview                                                            │
│  4 **Turbo Fleet** is a high-performance orchestration hub managed by             │
│    [@Turbo-the-tech-dev](https://github.com/Turbo-the-tech-dev). It is a          │
│    **Turborepo monorepo** designed for Electrical Engineering education (NEC 2026 │
│    compliance), AI Prompt Engineering, and specialized developer utilities. The   │
│    project integrates mobile applications (Flutter, Expo), AI logic templates,    │
│    and extensive DevOps automation.                                               │
│  5                                                                                │
│  6 ### Core Domains                                                               │
│  7 - **Electrical Engineering:** NEC 2026 compliance, conduit bending, load       │
│    calculations, and field reference tools.                                       │
│  8 - **AI/ML:** Advanced prompt engineering (CoT, few-shot), LLM fundamentals,    │
│    and diagnostic workflow templates.                                             │
│  9 - **Developer Utilities:** Bash CLI suites (DEATHSTAR), build telemetry, and   │
│    cross-sector automation (Imperial Monitoring).                                 │
│ 10 - **Education:** Math fundamentals and college bridge resources.               │
│ 11                                                                                │
│ 12 ---                                                                            │
│ 13                                                                                │
│ 14 ## Architecture & Technology Stack                                             │
│ 15 - **Orchestration:** [Turborepo](https://turbo.build/) with `npm workspaces`.  │
│ 16 - **Frontend/Mobile:**                                                         │
│ 17     - **Flutter (Dart):** `sectors/17-flutter` (NEC Interview Prep).           │
│ 18     - **Expo/React Native:** `sectors/19-expo` (Field Ops).                    │
│ 19     - **React:** `Electrician-PROMPT-GENIE` (AI Templates).                    │
│ 20 - **Backend/CLI:**                                                             │
│ 21     - **Node.js/TypeScript:** `DEATHSTAR`, `Electrician-PROMPT-GENIE`.         │
│ 22     - **Python:** `sectors/06-firestore`, `sectors/08-aws` (Automation         │
│    scripts).                                                                      │
│ 23     - **Bash:** Root-level scripts and `DEATHSTAR` suite.                      │
│ 24 - **DevOps:**                                                                  │
│ 25     - **Cloud:** AWS (Terraform).                                              │
│ 26     - **Orchestration:** Kubernetes (K8s manifests in `k8s/`).                 │
│ 27     - **CI/CD:** GitHub Actions (workflows in `.github/workflows/`).           │
│ 28     - **Monitoring:** Prometheus, Grafana, Alertmanager.                       │
│ 29                                                                                │
│ 30 ---                                                                            │
│ 31                                                                                │
│ 32 ## Building and Running                                                        │
│ 33                                                                                │
│ 34 ### Root Workspace Commands                                                    │
│ 35 ```bash                                                                        │
│ 36 npm install        # Install all dependencies across all workspaces            │
│ 37 npm run build      # Build all sectors via Turborepo                           │
│ 38 npm run test       # Run all unit tests across the fleet                       │
│ 39 npm run lint       # Run static analysis/type checking                         │
│ 40 ```                                                                            │
│ 41                                                                                │
│ 42 ### Specific Workspace Commands                                                │
│ 43 | Workspace | Command | Purpose |                                              │
│ 44 |-----------|---------|---------|                                              │
│ 45 | **DEATHSTAR** | `npm test` | Run TSX-based scoring tests |                   │
│ 46 | **PROMPT-GENIE** | `npm test` | Run AI template validation tests |           │
│ 47 | **Flutter App** | `flutter pub get && flutter test` | Manage Dart deps and   │
│    test |                                                                         │
│ 48 | **Expo App** | `npx expo start` | Start React Native dev server |            │
│ 49                                                                                │
│ 50 ### DevOps & Infrastructure                                                    │
│ 51 - **Terraform:** `make tf-plan` / `make tf-apply` (targets                     │
│    `sectors/08-aws/infrastructure`).                                              │
│ 52 - **Docker:** `docker-compose up -d` for local service orchestration.          │
│ 53 - **Deployment:** Managed via `IMPERIAL_PUSH.md` and automated GitHub Actions. │
│ 54                                                                                │
│ 55 ---                                                                            │
│ 56                                                                                │
│ 57 ## Development Conventions                                                     │
│ 58                                                                                │
│ 59 ### General Guidelines                                                         │
│ 60 - **Conventional Commits:** Use prefixes like `feat:`, `fix:`, `docs:`,        │
│    `chore:`.                                                                      │
│ 61 - **Safety-First Protocol:** All electrical logic must prioritize OSHA and     │
│    LOTO (Lockout/Tagout) procedures.                                              │
│ 62 - **Journeyman Mentor Tone:** Technical explanations should be practical and   │
│    veteran-styled.                                                                │
│ 63 - **Environment:** Primarily developed on **Termux (Android)**. Avoid          │
│    assumptions about native build toolchains (Xcode/Android Studio) unless        │
│    explicitly targeting CI.                                                       │
│ 64                                                                                │
│ 65 ### Code Style                                                                 │
│ 66 - **TypeScript:** Use `tsx` for running scripts and tests without a separate   │
│    build step where possible.                                                     │
│ 67 - **Flutter:** Feature-first architecture under `lib/src/`. Uses `Riverpod`    │
│    for state management.                                                          │
│ 68 - **React Native:** Three-layer pattern for calculators; utility functions     │
│    must be pure.                                                                  │
│ 69                                                                                │
│ 70 ### Imperial Monitoring (Sectors)                                              │
│ 71 Automation is categorized into "Sectors":                                      │
│ 72 - **Sector 02 (Gemini):** AI logic and linguistic telemetry.                   │
│ 73 - **Sector 08 (AWS):** Infrastructure and terminal history extraction.         │
│ 74 - **Sector 18 (Turbo Dev):** Build and deployment telemetry.                   │
│ 75                                                                                │
│ 76 ---                                                                            │
│ 77                                                                                │
│ 78 ## Key Files & Directories                                                     │
│ 79 - `MASTER-INDEX.md`: Full catalog of 25+ repositories in the ecosystem.        │
│ 80 - `DEVOPS.md`: Comprehensive runbook for infrastructure and deployment.        │
│ 81 - `CLAUDE.md`: Guidance for AI-assisted development workflows.                 │
│ 82 - `k8s/`: Kubernetes manifests for staging and production overlays.            │
│ 83 - `sectors/`: Specialized sub-projects and automation scripts.                 │
│ 84                                                                                │
│ 85 ---                                                                            │
│ 86 *Status: 151% OPERATIONAL | Last Updated: 2026-02-28*                          │
╰───────────────────────────────────────────────────────────────────────────────────╯
✦ The GEMINI.md file has been generated to provide comprehensive instructional context
  for this project.


  Project Summary: Turbo Fleet
  Turbo Fleet is a high-performance Turborepo monorepo managed by @Turbo-the-tech-dev
  (https://github.com/Turbo-the-tech-dev). It serves as an orchestration hub for over 25
  specialized repositories focused on Electrical Engineering (NEC 2026), AI Prompt
  Engineering, Mobile App Development (Flutter/Expo), and DevOps Automation.


  Key Highlights of GEMINI.md:
   * Architecture: Managed via Turborepo and npm workspaces.
   * Core Projects:
       * DEATHSTAR: Bash CLI and TypeScript scoring suite.
       * Electrician-PROMPT-GENIE: AI prompt templates for NEC compliance.
       * sectors/17-flutter: Flutter-based NEC Interview Prep.
       * sectors/19-expo: Expo/React Native Field Ops app.
   * Infrastructure: AWS (Terraform), Kubernetes (K8s manifests), and GitHub Actions.
   * Development Philosophy: Adheres to a "Safety-First Protocol" and "Journeyman Mentor"
     explanatory tone.


  The file is located at the project root:
  /data/data/com.termux/files/home/epic/root/GEMINI.md.
