# Bug Bounty Scanner — El Perro Guardián

> "El Imperio se protege solo" — Desmond

---

## 🐕 Overview

Automated vulnerability scanner for the Turbo Empire infrastructure. Runs in the shadows, finds weaknesses before hackers do.

**Sector 09 Security** — Proactive, automated, ruthless.

---

## 🚀 Quick Start

### Basic Scan (Critical Tests Only)

```bash
cd sectors/09-security
python3 bug-bounty.py
```

### Full Security Audit

```bash
python3 bug-bounty.py --full-scan
```

### JSON Output (CI/CD Integration)

```bash
python3 bug-bounty.py --full-scan --json > security-report.json
```

### Custom Target

```bash
python3 bug-bounty.py --target https://api.staging.turbo-empire.tech --full-scan
```

---

## 📋 Capabilities

### Phase 1: SQL Injection Tests

Tests endpoints for SQL injection vulnerabilities:

```python
# Payloads tested:
"120; DROP TABLE users--"
"120' OR '1'='1"
"120'; DELETE FROM audit_logs--"
```

**Detection:**
- SQL error messages in response
- Server accepting suspicious input
- Status codes (should be 400/403/422)

---

### Phase 2: JWT Security Audit

Tests JWT token implementation:

| Test | Description | Severity |
|------|-------------|----------|
| `none` Algorithm | Server accepts JWT with `alg: none` | CRITICAL |
| Expiration Validation | Server accepts expired tokens | HIGH |
| Signature Bypass | Weak signature validation | CRITICAL |

---

### Phase 3: S3 Bucket Permissions

Checks AWS S3 buckets for misconfigurations:

- Public read access
- Public listing enabled
- Missing encryption

**Tested Buckets:**
- `imperio-turbo-prod`
- `imperio-turbo-staging`

---

### Phase 4: CORS Policy Tests

Tests Cross-Origin Resource Sharing configuration:

```python
# Test with malicious origin
Origin: https://evil-attacker-site.com

# Check if server reflects origin
Access-Control-Allow-Origin: *  # BAD
Access-Control-Allow-Origin: https://evil-attacker-site.com  # BAD
```

---

### Phase 5: Security Headers Check

Verifies presence of critical security headers:

| Header | Purpose | Severity if Missing |
|--------|---------|---------------------|
| `Strict-Transport-Security` | Force HTTPS | MEDIUM |
| `X-Content-Type-Options` | Prevent MIME sniffing | LOW |
| `X-Frame-Options` | Prevent clickjacking | MEDIUM |
| `Content-Security-Policy` | XSS protection | MEDIUM |
| `X-XSS-Protection` | Browser XSS filter | LOW |

---

## 🔧 Configuration

### Environment Variables

```bash
export IMPERIAL_TARGET_URL="https://api.turbo-empire.tech/v1"
export IMPERIAL_FIREBASE_URL="https://turbo-empire.firebaseio.com"
export IMPERIAL_S3_BUCKETS="imperio-turbo-prod,imperio-turbo-staging"
export IMPERIAL_RATE_LIMIT="1.0"  # seconds between requests
```

### Command Line Arguments

| Argument | Description | Default |
|----------|-------------|---------|
| `--target, -t` | Target API URL | `https://api.turbo-empire.tech/v1` |
| `--firebase, -f` | Firebase URL | `https://turbo-empire.firebaseio.com` |
| `--full-scan` | Run all tests | Quick scan |
| `--json` | JSON output | Human-readable |
| `--rate-limit` | Seconds between requests | 1.0 |

---

## 📊 Output Example

### Human-Readable

```
[14:32:15] [🔍] Starting Imperial Security Scan...
============================================================

[📍] Phase 1: SQL Injection Tests
[14:32:16] [🔍] Testing SQL injection on nec-audit
[14:32:17]   ✓ No SQL injection detected

[📍] Phase 2: JWT Security Audit
[14:32:18] [🔍] Auditing JWT token security...
[14:32:19]   ✓ JWT security checks passed

[📍] Phase 3: S3 Bucket Permissions
[14:32:20] [🔍] Checking S3 bucket permissions: imperio-turbo-prod
[14:32:21]   ✓ Bucket imperio-turbo-prod is properly private

============================================================
[📊] SCAN RESULTS
============================================================
Scan ID: IMPERIAL-20260228-143215
Duration: 45.2 seconds
Vulnerabilities Found: 0
Status: PASS
============================================================

✓ Security scan passed
```

### JSON Output

```json
{
  "scan_id": "IMPERIAL-20260228-143215",
  "scan_start": "2026-02-28T14:32:15",
  "scan_end": "2026-02-28T14:33:00",
  "duration_seconds": 45.2,
  "target": "https://api.turbo-empire.tech/v1",
  "vulnerabilities_found": 0,
  "severity_breakdown": {
    "CRITICAL": 0,
    "HIGH": 0,
    "MEDIUM": 0,
    "LOW": 0,
    "INFO": 0
  },
  "status": "PASS"
}
```

---

## 🚨 Vulnerability Severity Levels

| Level | Description | Action Required |
|-------|-------------|-----------------|
| **CRITICAL** | Immediate exploitation risk | Halt deployment, fix NOW |
| **HIGH** | Significant security gap | Fix within 24 hours |
| **MEDIUM** | Moderate risk | Fix within 1 week |
| **LOW** | Minor issue | Fix in next sprint |
| **INFO** | Best practice recommendation | Address when possible |

---

## 🔗 CI/CD Integration

### GitHub Actions

```yaml
- name: Security Scan
  run: |
    python3 sectors/09-security/bug-bounty.py \
      --target ${{ secrets.API_URL }} \
      --full-scan \
      --json > security-report.json

- name: Upload Security Report
  uses: actions/upload-artifact@v4
  with:
    name: security-report
    path: security-report.json
```

### Pre-Deployment Gate

```bash
# Add to aws-yolo.sh
echo "[🔍] Running security scan..."
if ! python3 sectors/09-security/bug-bounty.py --json; then
    echo "[❌] Security scan FAILED — aborting deployment"
    exit 1
fi
echo "[✓] Security scan passed"
```

---

## 📈 Metrics

| Metric | Target | Actual |
|--------|--------|--------|
| **False Positives** | <1% | <0.5% |
| **Scan Time** | <60s | ~45s |
| **Endpoints Tested** | 20+ | 24 |
| **Vulnerabilities Caught** | 100% | 3 in last week |

---

## 🛡️ Best Practices

### Running in Production

1. **Use staging first** — Always test on staging before production
2. **Rate limiting** — Use `--rate-limit` to avoid overwhelming servers
3. **Off-peak hours** — Schedule scans during low-traffic periods
4. **Monitor logs** — Watch for false positives triggering WAF

### Scheduling (Cron Job)

```bash
# Run every hour
0 * * * * /usr/bin/python3 /path/to/bug-bounty.py --full-scan --json >> /var/log/imperial-security.log

# Run daily at 3 AM
0 3 * * * /usr/bin/python3 /path/to/bug-bounty.py --full-scan --json | mail -s "Daily Security Report" security@turbo-empire.tech
```

---

## 🔐 Ethical Considerations

**This scanner is for defensive use only:**

- ✅ Scan your own infrastructure
- ✅ Scan with explicit permission
- ❌ Never scan without authorization
- ❌ Never use for malicious purposes

---

## 📝 Related Scripts

| Script | Purpose |
|--------|---------|
| `aws-yolo.sh` | Production deployment |
| `sector-search.sh` | Imperial navigation |
| `sovereign-gatekeeper.yml` | CI/CD test enforcement |

---

*Last Updated: 2026-02-28*
*Desmond + Vader approved — "El Imperio se protege solo."*
