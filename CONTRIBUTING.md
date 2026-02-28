# Contributing to Turbo-the-tech-dev Repositories

Thank you for your interest in contributing! This document outlines guidelines for contributing to any repository in the [@Turbo-the-tech-dev](https://github.com/Turbo-the-tech-dev) organization.

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

**Examples:**
```
feat: add conduit fill calculator for EMT
fix: correct NEC 220.42 load calculation formula
docs: update README with verified external links
```

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
- Tests use CommonJS `require()` syntax (Jest).
- Run `npm test` before submitting.

### sovereign-circuit-academy (Flutter)

- Follow feature-first architecture under `lib/features/`.
- State management via Riverpod — do not introduce other state solutions.
- Run `flutter test` before submitting.

### Python Scripts (sovereign-circuit-academy)

- Scripts must be standalone — no shared module dependencies.
- Dependencies: `pandas`, `matplotlib` only.
- Include a docstring explaining NEC article applicability.

---

## License

By contributing, you agree that your contributions will be licensed under the same [MIT License](LICENSE) that covers this project.
