# AGENTS.md — Agentic Coding Guidelines

Guidelines for AI agents working in the Turbo-the-tech-dev root workspace repository.

## Repository Context

This is the **root orchestration repository** for 25+ sub-repositories spanning React Native, Flutter, Python, Bash, .NET, and vanilla JS projects. Development occurs primarily on **Termux (Android)**.

---

## Build, Lint & Test Commands

### By Technology Stack

**Bash Scripts:**
```bash
# Lint with shellcheck (if available)
shellcheck script.sh

# Dry-run test
bash script.sh --dry-run
```

**React Native (Expo):**
```bash
cd Turbo-Repos/Electrician
npm install
npm test              # Run tests
npm run lint          # ESLint
npx tsc --noEmit      # Type check
```

**Flutter:**
```bash
cd sovereign-circuit-academy/vader-academy-app
flutter pub get
flutter test          # Run all tests
flutter analyze       # Static analysis
```

**Python:**
```bash
# Run single test
python3 -m pytest path/to/test_file.py::test_function -v

# Run all tests
python3 -m pytest

# Lint
python3 -m flake8
python3 -m black --check .
```

**.NET Core:**
```bash
cd Electrical-Core-API
dotnet build
dotnet test           # Run tests
dotnet test --filter "FullyQualifiedName~TestClassName"  # Single test class
```

**Vanilla JS (Todolite):**
```bash
# No build step—open index.html directly
# For linting (if eslint config exists):
npx eslint *.js
```

---

## Code Style Guidelines

### Git Conventions

**Commit Messages (Conventional Commits):**
```
type(scope): brief message

Longer explanation if needed.
```

**Types:** `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`, `test:`

**Branch Naming:**
- `feature/short-description`
- `fix/short-description`
- `docs/short-description`
- `refactor/short-description`

### Bash Scripts

```bash
#!/usr/bin/env bash
set -euo pipefail

# Indent: 2 spaces (not tabs)
# Quote all variables: "${var}"
# Use readonly for constants
# Function names: snake_case

readonly MAX_RETRIES=3

process_file() {
  local file_path="${1}"
  echo "Processing: ${file_path}"
}
```

### Python

- Follow PEP 8
- Use type hints where practical
- Docstrings for all functions (Google style preferred)
- 4-space indentation

```python
def calculate_load(amperage: float, voltage: float) -> float:
    """Calculate electrical load in watts.
    
    Args:
        amperage: Current in amperes
        voltage: Voltage in volts
        
    Returns:
        Power in watts
    """
    return amperage * voltage
```

### TypeScript/JavaScript

- 2-space indentation
- Prefer `const` over `let`
- Use ESLint configuration from project
- JSDoc for exported functions
- Trailing commas in multiline objects/arrays

```typescript
/** Calculate conduit fill percentage */
export const calculateFillPercent = (
  conductorArea: number,
  conduitArea: number,
): number => {
  return (conductorArea / conduitArea) * 100;
};
```

### Flutter/Dart

- Follow Effective Dart guidelines
- Use Riverpod for state management
- Feature-first architecture
- 2-space indentation

### Markdown

- Use `#` for headings (not underlines)
- Keep line length under 100 characters
- Use backticks for code references
- Provide examples where helpful

---

## Error Handling

### Bash
- Always check exit codes: `cmd || exit 1`
- Use `set -euo pipefail` at script start
- Validate inputs before processing

### Python
- Use specific exception types
- Log errors with context
- Never swallow exceptions silently

### JavaScript/TypeScript
- Use try/catch for async operations
- Validate API responses
- Propagate errors with context

---

## Platform Constraints

**Primary Environment: Termux (Android)**
- No native build toolchain (Xcode/Android Studio)
- Use Expo for React Native development
- Flutter uses CLI commands (flutter pub/run)
- Python runs directly without compilation
- Bash is the primary CLI tool

---

## Critical Files Reference

| File | Purpose |
|------|---------|
| `MASTER-INDEX.md` | Catalog of all 25 GitHub repositories |
| `CLAUDE.md` | Claude Code project guidance |
| `QWEN.md` | Qwen workspace context |
| `HOLOCRON.md` | Daily priorities and navigation aliases |
| `CONTRIBUTING.md` | Full contribution guidelines |
| `.github/workflows/` | GitHub Actions automation |

---

## Navigation Aliases (Dark-Keys)

```bash
h    # HOLOCRON.md - Master command center
t    # Today's Conquests
s    # System Status
e    # Electrical Portal
v    # The Vault (Imperial Directives)
vp   # VP Strategy
vpt  # VP TODOS
```

---

## Testing Requirements

Before submitting changes:
1. Test on Termux (primary platform)
2. Use `--dry-run` flags where available
3. Run appropriate test suite for the technology
4. Verify no breaking changes to existing workflows

---

## Security

- Never commit API keys, credentials, or secrets
- Use `.env` files for sensitive configuration
- Automated secret scanning runs on all pushes
- See `SECURITY.md` for vulnerability reporting

---

*Last Updated: 2026-02-28*
