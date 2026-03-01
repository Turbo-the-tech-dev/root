# Contributing to Turbo-the-tech-dev Repositories 🚀

Thank you for your interest in contributing! This document outlines guidelines for contributing to any repository in the [@Turbo-the-tech-dev](https://github.com/Turbo-the-tech-dev) organization.

---

## 📜 Workspace Contract (Blue Hat Standard)

To ensure the root orchestration hub functions correctly, every sub-package in the `workspaces/` directory MUST implement the following scripts in its `package.json`:

1.  **`test`**: Must run the package's unit tests. If no tests exist yet, it should be a no-op (e.g., `"test": "echo 'No tests yet'"`).
2.  **`build`**: Must produce a build artifact if applicable. If the package does not require building (e.g., pure JS/TS library without transpilation), it should be a no-op.
3.  **`lint`**: Must run a static analysis tool (e.g., `eslint` or `prettier`).

### Root-Level Commands
Always run commands from the project root using `turbo` for optimized, cached execution:
```bash
npm run build   # Builds all packages in topological order
npm run test    # Runs all tests in parallel (if independent)
npm run lint    # Runs all linters
```

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Commit Convention](#commit-convention)
- [Pull Request Process](#pull-request-process)
- [Repository-Specific Guidelines](#repository-specific-guidelines)
- [License](#license)

---

## Code of Conduct

- Be respectful and constructive in all interactions.
- Focus on technical accuracy, especially for NEC references and electrical standards.
- Credit sources when adding external resources or references.

---

## How to Contribute

1. **Fork** the repository you want to contribute to.
2. **Clone** your fork locally.
3. **Create a branch** with a descriptive name:
   ```bash
   git checkout -b feat/your-feature-name
   ```
4. **Make your changes**, following the guidelines below.
5. **Commit** with a conventional commit message (see below).
6. **Push** your branch to your fork.
7. **Open a Pull Request** against the `master` branch.

---

## Commit Convention

This organization uses [Conventional Commits](https://www.conventionalcommits.org/):

| Prefix | Use Case |
|--------|----------|
| `feat:` | New feature or content |
| `fix:` | Bug fix or correction |
| `docs:` | Documentation changes |
| `chore:` | Maintenance, tooling, config |
| `refactor:` | Code restructuring without behavior change |
| `test:` | Adding or updating tests |

---

## Pull Request Process

1. Ensure your branch is up to date with `master` before opening a PR.
2. Provide a clear description of what changed and why.
3. For NEC or electrical content, cite the specific article and edition (e.g., *NEC 2023 Article 220.42*).
4. For external links, verify they return HTTP 200 before including them.
5. PRs require at least one review before merging.

---

## Repository-Specific Guidelines

### Electrician-PROMPT-GENIE

- Utility functions in `src/utils/` must be **pure** — no React imports.
- Run `npm test` before submitting.

### Sub-projects
- Each sub-project has its own directory and its own git repository (when managed by Turbo Fleet).
- Always `cd` into the project directory before running project-specific commands.

---

## License

By contributing, you agree that your contributions will be licensed under the same [MIT License](LICENSE) that covers this project.

---
*Maintained by Master Turbo & C-3PO*
