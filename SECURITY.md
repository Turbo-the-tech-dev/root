# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this project, **please do not open a public issue**. Instead, report it privately to help protect users before a fix is available.

### How to Report

1. **Email:** Send a detailed report to `security@turbo-the-tech-dev.com`
2. **Include:**
   - Description of the vulnerability
   - Steps to reproduce (proof of concept)
   - Potential impact
   - Any suggested fixes
3. **Response Time:** We aim to respond within **48 hours**
4. **Coordination:** We will work with you on a fix and coordinated disclosure timeline

### GitHub Private Vulnerability Reporting

You can also use GitHub's private vulnerability reporting feature:

1. Go to the repository **Security** tab
2. Click **Report a vulnerability**
3. Follow GitHub's guided form

## Supported Versions

| Version | Status | Support Until |
|---------|--------|---|
| 2026.02.x | Current | Active |
| 2026.01.x | Legacy | 2026-03-31 |
| < 2026.01 | Unsupported | - |

## Security Considerations

### Bash Scripts

- All scripts use `set -euo pipefail` to prevent dangerous behavior
- File operations use `cp --no-clobber` to prevent overwrites
- System paths are explicitly scoped (`/root/files/`, never `/usr/`, `/etc/`)
- Symlinks are never followed in batch operations

### File Handling

- No arbitrary command execution from user input
- All paths are validated before use
- Temporary files are cleaned up on exit or error
- Batch logs are readable only by the owner

## Responsible Disclosure

We are committed to responsible security disclosure:

- **Do not** publicly disclose the vulnerability until we've had time to fix it
- **Do** give us a reasonable timeframe (14-30 days) to prepare a patch
- **Do** credit you in the fix announcement if you wish

## Security Best Practices for Users

If using this project:

- Keep dependencies updated
- Review shell scripts before running with elevated privileges
- Use in isolated environments when first testing
- Report any suspicious behavior to security contacts above

---

**Contact:** security@turbo-the-tech-dev.com
**Last Updated:** 2026-02-23
