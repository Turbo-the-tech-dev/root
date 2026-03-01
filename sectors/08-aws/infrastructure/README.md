# Turbo Fleet Infrastructure (Sector 08-AWS)

## Overview

This directory contains the Infrastructure as Code (IaC) for Turbo Fleet, managed via Terraform.

## Resources Provisioned

| Resource | Purpose |
|----------|---------|
| S3 Buckets | Static assets, build artifacts, logs |
| CloudFront | CDN for static assets |
| ACM | SSL/TLS certificates for custom domains |
| Route53 | DNS records (optional) |
| IAM | GitHub Actions OIDC role |

## Quick Start

### Prerequisites

- Terraform >= 1.6.0
- AWS CLI configured
- AWS credentials with appropriate permissions

### Deploy Infrastructure

```bash
# Staging (default)
./sectors/08-aws/imperial-arsenal.sh

# Production
./sectors/08-aws/imperial-arsenal.sh production
```

### Or use Make

```bash
# Initialize
make tf-init ENV=staging

# Plan
make tf-plan ENV=staging

# Apply
make tf-apply ENV=staging

# Destroy (DANGEROUS)
make tf-destroy ENV=staging
```

## Environments

| Environment | Variables File | Destruction Protection |
|-------------|----------------|------------------------|
| Staging | `terraform.tfvars` | Disabled |
| Production | `terraform.tfvars.production` | **Enabled** |

## GitHub Actions OIDC

The infrastructure creates an IAM role that allows GitHub Actions to authenticate via OIDC:

```yaml
- uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: ${{ vars.AWS_ROLE_ARN }}
    aws-region: us-east-1
```

## Outputs

After deployment, you'll receive:

- `static_bucket_name` - S3 bucket for static assets
- `cloudfront_distribution_url` - CDN URL
- `github_actions_role_arn` - IAM role for CI/CD

## Security

- All buckets have server-side encryption enabled
- Public access is blocked at the bucket level
- CloudFront uses OAI for S3 access
- Production has destruction protection enabled

## Cleanup

```bash
# Nuke everything (staging)
./sectors/08-aws/imperial-purge.sh staging

# Nuke everything (production - DANGEROUS)
./sectors/08-aws/imperial-purge.sh production
```
