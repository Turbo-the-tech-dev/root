# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

This is the **root workspace repository** (`Turbo-the-tech-dev/root` on GitHub). It orchestrates deployment and tracking of 25+ sub-repositories spanning educational materials, AI/ML systems, electrical engineering tools, and utility projects. The repository itself contains:

- **MASTER-INDEX.md**: Complete catalog of all 25 deployed repositories with descriptions and links
- **GitHub Actions workflows**: Automated monthly reports, secret scanning, weekly metrics
- **Deployment scripts**: Push all local repos to GitHub and cleanup utilities
- **Project-specific CLAUDEs**: Each major sub-project (Electrician, DEATHSTAR, etc.) has its own CLAUDE.md with detailed architecture

## Key Projects

This workspace orchestrates several active projects:

1. **Turbo-Repos/Electrician** — React Native + Expo calculator app for electrical engineering education (three-layer architecture: navigation → containers → utilities)
2. **sovereign-circuit-academy** — Flutter mobile app with NEC codes, conduit bending, load calculators (Riverpod state management, feature-first architecture)
3. **Turbo-Repos/DEATHSTAR** — Bash CLI tool suite for automation and scripting
4. **sovereign-circuit-academy (Python)** — Standalone Python utilities for NEC compliance and electrical calculations
5. **Todolite** — Vanilla JavaScript minimalist to-do app (no build step)

See `MASTER-INDEX.md` for the complete catalog of 25 repositories.

## Common Commands

### Deploy and Manage Repositories

```bash
# Push all local repositories to GitHub
/root/push_all_repos.sh

# Clean up local repository copies (after successful push)
/root/cleanup_local_repos.sh
```

### Check Repository Status

```bash
# View the complete repository index
cat MASTER-INDEX.md

# Check current workspace status
git status

# View recent workspace commits
git log --oneline -10
```

### For Sub-Project Development

Each major sub-project has its own git repository and CLAUDE.md with detailed setup instructions:

```bash
cd Turbo-Repos/Electrician
npm install && npm test              # React Native project

cd sovereign-circuit-academy/vader-academy-app
flutter pub get && flutter run       # Flutter project

python3 sovereign-circuit-academy/box_fill_calculator.py  # Python tools

# Todolite has no build process—open index.html directly
```

## Repository Structure and Architecture

### Workspace Organization

```
/root (orchestration repo)
├── MASTER-INDEX.md          # Catalog of all 25 GitHub repositories
├── CLAUDE.md                # This file
├── DEATHSTAR/               # Bash CLI tools
├── __THE_SANDBOX__/         # README describing major projects
├── push_all_repos.sh        # Deploy script
├── cleanup_local_repos.sh   # Cleanup script
└── .github/workflows/       # GitHub Actions for reporting & scanning
```

### Multi-Repository Architecture

This workspace uses a **monorepo-inspired pattern** with independently managed git repositories. Key architectural principles:

- **Each sub-project is a separate git repository**: Always `cd` into the project before running git commands
- **Conventional commits**: Use `feat:`, `fix:`, `docs:`, `refactor:` prefixes across all repos
- **GitHub Actions**: Automated workflows for monthly reporting, security scanning, and metrics collection
- **Deployment strategy**: Central push script coordinates pushing all repos to GitHub in sequence

### Platform Constraints

Development occurs on **Termux (Android)**—no native build toolchain (Xcode/Android Studio). This means:
- Node.js/npm projects use Expo for React Native development
- Flutter projects use flutter pub/run commands
- Python scripts run directly without compilation
- Bash scripts are the primary CLI tool suite

## Convention Notes

- **Each repo is independent**: Git commands operate within their own repository
- **Sub-project CLAUDEs**: Reference detailed architecture guides in `Turbo-Repos/Electrician/CLAUDE.md`, etc.
- **Push script workflow**: Run `push_all_repos.sh`, then `cleanup_local_repos.sh` to manage local disk space
- **GitHub organization**: All repositories deployed to [@Turbo-the-tech-dev](https://github.com/Turbo-the-tech-dev)

## Reporting and Automation

GitHub Actions workflows run on schedule:
- **Monthly Report** (`monthly-report.yml`): Generates fleet report on the 1st of each month
- **Secret Scanning** (`secret-scan.yml`): Automated security scanning
- **Weekly Metrics** (`weekly-metrics.yml`): Tracks repository metrics

View workflow status and history in GitHub Actions.
