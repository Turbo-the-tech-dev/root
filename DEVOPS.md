# DevOps Runbook — Turbo Fleet

## Quick Reference

| Command | Description |
|---------|-------------|
| `make install` | Install all workspace dependencies |
| `make test` | Run all tests across workspaces |
| `make build` | Build all workspaces |
| `make docker-build` | Build Docker images locally |
| `make tf-init` | Initialize Terraform |
| `make tf-plan` | Preview infrastructure changes |
| `make tf-apply` | Apply infrastructure changes |
| `./sectors/08-aws/imperial-purge.sh staging` | Destroy staging infrastructure |

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        GitHub Actions                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │   Lint      │→ │    Test     │→ │  Build & Deploy         │ │
│  └─────────────┘  └─────────────┘  └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                         AWS Cloud                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │  S3 Bucket  │← │ CloudFront  │← │  ACM Certificate        │ │
│  │  (Static)   │  │    (CDN)    │  │  (Custom Domain)        │ │
│  └─────────────┘  └─────────────┘  └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Workspaces

| Workspace | Port | Description |
|-----------|------|-------------|
| Electrician-PROMPT-GENIE | 3001 | Interview prep, NEC 2026 logic |
| DEATHSTAR | 3002 | Scoring engine |

## Local Development

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

## Infrastructure

### Deploy Staging

```bash
./sectors/08-aws/imperial-arsenal.sh staging
```

### Deploy Production

```bash
./sectors/08-aws/imperial-arsenal.sh production
```

### Emergency Destruction

```bash
# Staging only - production requires confirmation
./sectors/08-aws/imperial-purge.sh staging
```

## CI/CD Pipeline

### Trigger Conditions

| Event | Action |
|-------|--------|
| PR opened | Run tests, lint, security scan |
| Push to main | Run tests + deploy to staging |
| Manual workflow_dispatch | Deploy to staging or production |

### Required Secrets

Configure in GitHub Settings > Secrets and variables > Actions:

| Secret | Description |
|--------|-------------|
| `SLACK_WEBHOOK_URL` | Slack notification webhook (optional) |

### Required Environment Variables

Configure per environment in GitHub Settings > Environments:

| Variable | Description |
|----------|-------------|
| `AWS_ROLE_ARN` | IAM role for OIDC authentication |
| `S3_BUCKET_NAME` | Target S3 bucket |
| `CLOUDFRONT_DISTRIBUTION_ID` | CloudFront distribution to invalidate |

## Security

- All containers run as non-root user
- S3 buckets have public access blocked
- CloudFront uses Origin Access Identity
- Terraform state stored in S3 with locking
- Production has destruction protection enabled

## Troubleshooting

### Terraform init fails

```bash
# Clear terraform cache
rm -rf sectors/08-aws/infrastructure/.terraform
make tf-init
```

### Docker build fails

```bash
# Clean build
make clean
docker builder prune -f
make docker-build
```

### GitHub Actions OIDC fails

1. Verify IAM role trust policy allows `token.actions.githubusercontent.com`
2. Check the `aud` claim matches `sts.amazonaws.com`
3. Verify the `sub` claim pattern matches your repo

## On-Call

### PagerDuty Integration

Configure Slack webhook for deployment notifications:

1. Create incoming webhook in Slack
2. Add `SLACK_WEBHOOK_URL` to GitHub repository secrets

### Rollback Procedure

1. Identify last known good commit
2. Trigger workflow_dispatch with that commit
3. Or manually sync S3 from backup bucket
