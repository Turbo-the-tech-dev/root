# Contributing to Turbo Fleet

Thank you for your interest in contributing! This document provides guidelines and instructions for participating in the Turbo-the-tech-dev project ecosystem.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** to your local machine
3. **Create a feature branch** from `main` or `master`
4. **Make your changes**, following the guidelines below
5. **Push to your fork** and submit a **Pull Request**

## Branch Naming

Use conventional prefixes for branches:

```
feature/short-description           (new features)
fix/short-description              (bug fixes)
docs/short-description             (documentation)
refactor/short-description         (code improvements)
chore/short-description            (maintenance)
```

**Example:** `feature/add-nec-calculator` or `fix/symlink-status-update`

## Commit Messages

Follow **Conventional Commits** format:

```
type(scope): brief message

Longer explanation if needed.
```

**Supported Types:**
- `feat:` — A new feature
- `fix:` — A bug fix
- `docs:` — Documentation changes
- `refactor:` — Code refactoring (no feature/bug changes)
- `chore:` — Build, CI, dependency updates
- `test:` — Test additions or fixes

**Example:**
```
feat(file-collector): add batch processing for large file sets

Implement BATCH_SIZE=50 with checkpoint resumability.
Allows killing and resuming without data loss.
```

## Code Style

### Bash Scripts
- Use `set -euo pipefail` at the start
- Indent with 2 spaces (not tabs)
- Name functions with `snake_case`
- Add comments for non-obvious logic
- Use `readonly` for constants
- Quote all variable expansions: `"${var}"`

### Python
- Follow [PEP 8](https://www.python.org/dev/peps/pep-0008/)
- Use type hints where practical
- Write docstrings for all functions

### TypeScript/JavaScript
- Use ESLint configuration from the project
- Format with Prettier (2-space indent)
- Prefer `const` over `let`
- Add JSDoc comments for exported functions

### Markdown
- Use `#` for headings (not underlines)
- Keep line length under 100 characters
- Use backticks for code references
- Provide examples where helpful

## Pull Request Process

1. **Title**: Use conventional commit format in PR title
2. **Description**: Explain *why* this change, not just *what*
3. **Link issues**: Reference related issues (e.g., "Closes #26")
4. **Tests**: Include tests for new features or bug fixes
5. **Docs**: Update relevant documentation
6. **Review**: Be responsive to feedback

**Example PR description:**
```markdown
## Description
Adds batch processing to file_collector.sh to handle large file sets safely.

## Why
Prevents system disruption when collecting thousands of files across /root.

## Changes
- Implement BATCH_SIZE=50
- Add checkpoint resumability with `--resume` flag
- Create BATCH_LOG for progress tracking

Closes #15
```

## Testing

Before submitting a PR:

- **Dry-run tests**: Use `--dry-run` flags where available
- **Manual testing**: Test your changes on Termux (primary platform)
- **Existing tests**: Run `npm test` or equivalent
- **Edge cases**: Consider empty files, symlinks, special characters

## Documentation

Update docs if your PR affects:

- User-visible behavior
- Installation or setup steps
- New commands or options
- Architecture or design decisions

## Code Review

Reviewers will look for:

- ✅ Code quality and readability
- ✅ Adherence to commit conventions
- ✅ Test coverage
- ✅ Documentation completeness
- ✅ No breaking changes (unless intentional and discussed)

**Respond to feedback** — Questions are not criticism, they're collaborative.

## Community & Help

- **Questions?** Open a [Discussion](https://github.com/Turbo-the-tech-dev/root/discussions) or issue
- **Found a bug?** Use the [Bug Report template](/.github/ISSUE_TEMPLATE/bug_report.yml)
- **Have an idea?** Use the [Feature Request template](/.github/ISSUE_TEMPLATE/feature_request.yml)
- **Security issue?** See [SECURITY.md](./SECURITY.md)

## License

By contributing, you agree that your contributions will be licensed under the project's license (see LICENSE file).

---

**Thank you for contributing to Turbo Fleet!** ⚡🔌

---

**Last Updated:** 2026-02-23
