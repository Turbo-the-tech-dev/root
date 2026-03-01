# Turbo-the-tech-dev Root Workspace

**Organization:** [@Turbo-the-tech-dev](https://github.com/Turbo-the-tech-dev)
**Last Updated:** 2026-02-23
**Branch:** `27-claude`

---

## Overview

Root orchestration repository for 25+ sub-repositories spanning educational materials, AI/ML systems, electrical engineering tools, and utility projects.

## 🗂️ Directory Structure

### `/files/` — File Organization (53 extensions)
sh, py, js, ts, jsx, tsx, html, css, json, yaml, md, rs, go, java, c, cpp, rb, php, swift, kt, scala, r, lua, hs, and 28+ more

Each with README.md, organized files, and timestamped logs.

**Tool:** `file_collector.sh` — batch scan → copy → commit → cleanup

### `/scripts_workspace/` — Automation Suite
```
utilities/       (4 core scripts)
drive-management/  (clone & sync)
git-training/    (git workflows)
master-control/  (repo verification)
documentation/   (11 markdown guides)
2026-02-23-work/ (session output)
```

### `/shifts/` — Shift Work Tracking
```
1/, 2/, 3/       (shift workspaces)
master/          (consolidated master)
SHIFT_STATUS.md  (live status, symlinked to all shifts)
GITHUB_CONSISTENCY_PLAN.md
```

### `/gemini/` — Gemini AI Workspace
```
README.md
TEAM_TODOS_10_HEADLESS_GEMINI.md
```

### `/__THE_SANDBOX__/` — Nested Testing
```
SANDBOX_01 to SANDBOX_05
Each with nested _01 to _03 sub-sandboxes
For isolated experimentation
```

### `SHIFT_2_SANDBOX/`, `SHIFT_3_SANDBOX/`
Multi-worker shift-based testing with blocked/completed/deliverables/work dirs

---

## 📦 Main Projects (25+)

See **MASTER-INDEX.md** for complete catalog.

**Key:**
- Electrician — React Native + Expo calculator
- sovereign-circuit-academy — Flutter app (NEC codes, conduit bending)
- DEATHSTAR — Bash CLI tools
- Todolite — Vanilla JS to-do app

---

## 🚀 Quick Commands

```bash
# Check repos
bash scripts_workspace/master-control/verify-repos.sh

# Organize files
bash file_collector.sh --dry-run
bash file_collector.sh --resume

# Git workflow
bash scripts_workspace/git-training/git-workflow.sh . "feat: message"

# Clone scripts repo
bash scripts_workspace/drive-management/clone-scripts-repo.sh
```

---

## 📋 Critical Files

| File | Purpose |
|------|---------|
| CLAUDE.md | Project guidance |
| MASTER-INDEX.md | All 25 repos |
| file_collector.sh | Batch organizer |
| index.html | Web dashboard |
| .claude/plans/ | Implementation plans |

---

## 🎯 Platform

- **Environment:** Termux (Android)
- **Organization:** [@Turbo-the-tech-dev](https://github.com/Turbo-the-tech-dev)
- **Conventions:** `feat:` `fix:` `docs:` `refactor:`

---

**Status:** Active | **Contributors:** [@Turbo-the-tech-dev](https://github.com/Turbo-the-tech-dev)
