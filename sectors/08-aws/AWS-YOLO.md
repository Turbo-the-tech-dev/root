# AWS YOLO Deployment Protocol

> "The path of the technological warrior" — Desmond

---

## ⚠️ WARNING

This script bypasses standard safety checks for **maximum deployment velocity**.

**Use ONLY when:**
- ✅ You've tested locally
- ✅ Code is Desmond-approved
- ✅ You accept full responsibility for production

---

## 🚀 Quick Start

### Set Environment Variables

```bash
export S3_BUCKET="imperio-turbo-prod"
export CLOUDFRONT_ID="E1234567890ABC"
```

### Run YOLO Deployment

```bash
# Interactive mode (asks for confirmation)
./aws-yolo.sh

# Force mode (no confirmation, CI/CD friendly)
./aws-yolo.sh --force
```

---

## 📋 What This Script Does

### Step 1: Pre-Flight Checks

- Verifies AWS CLI is installed
- Checks build directory exists
- Validates S3 bucket is configured
- Warns if CloudFront ID is missing

### Step 2: S3 Deployment

```bash
aws s3 sync ./build/web s3://$S3_BUCKET/ --delete
```

- Syncs all files to S3
- `--delete` removes old files (YOLO mode)
- Sets aggressive cache headers for static assets
- HTML files get no-cache headers

### Step 3: CloudFront Invalidation

```bash
aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_ID --paths "/*"
```

- Invalidates entire cache
- Waits for completion
- Global propagation in seconds

### Step 4: Verification

- Checks index.html exists
- Counts deployed files
- Shows distribution URL

---

## 🔧 Configuration

| Variable | Required | Description |
|----------|----------|-------------|
| `S3_BUCKET` | ✅ | S3 bucket name for deployment |
| `CLOUDFRONT_ID` | ❌ | CloudFront distribution ID |

---

## 📊 Post-Deployment Metrics

After successful deployment:

| Metric | Target | Status |
|--------|--------|--------|
| Downtime | 0 seconds | ✅ Blue-Green implicit |
| Files Deployed | Varies | Shown in output |
| CloudFront Propagation | <60 seconds | Global |
| Confianza del Jefe | 100% | Desmond-approved |

---

## 🚨 Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Bugs in production | HIGH | Test locally first |
| No automatic rollback | MEDIUM | Enable S3 versioning |
| CloudFront costs | LOW | Limit invalidations |
| Accidental deployment | MEDIUM | Use `--force` carefully |

---

## 🛡️ Safety Alternatives

If YOLO is too spicy, use the standard deployment:

```bash
# Standard deployment (with tests)
make tf-apply ENV=staging

# Staging deployment
./sectors/08-aws/imperial-arsenal.sh staging

# Kubernetes deployment
make argocd-sync-staging
```

---

## 📝 Example Output

```
╔═══════════════════════════════════════════════════════════╗
║     AWS YOLO — Imperial Production Deployment             ║
╚═══════════════════════════════════════════════════════════╝

[INFO] Checking prerequisites...
[SUCCESS] Prerequisites check passed

[INFO] Deploying to S3: imperio-turbo-prod
[SUCCESS] S3 deployment complete

[INFO] Invalidating CloudFront: E1234567890ABC
[SUCCESS] CloudFront invalidation complete

[INFO] Verifying deployment...
[SUCCESS] ✓ index.html deployed
[SUCCESS] ✓ 47 files deployed
[SUCCESS] ✓ Distribution URL: https://d123.cloudfront.net

╔═══════════════════════════════════════════════════════════╗
║     🚀 DOMINACIÓN GLOBAL COMPLETADA                     ║
║     El Imperio está LIVE                                ║
╚═══════════════════════════════════════════════════════════╝
```

---

## 🔗 Related Scripts

| Script | Purpose |
|--------|---------|
| `imperial-arsenal.sh` | Terraform infrastructure deploy |
| `imperial-purge.sh` | Infrastructure destruction |
| `sector-search.sh` | Imperial navigation |

---

*Last Updated: 2026-02-28*
*Desmond + Turbo approved — "Eficiencia sobre miedo."*
