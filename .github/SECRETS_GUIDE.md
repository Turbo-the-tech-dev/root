# GitHub Secrets Configuration Guide

## Required Secrets (Repository Level)

Configure these in **Settings → Secrets and variables → Actions → New repository secret**:

| Secret Name | Description | Where to Get |
|-------------|-------------|--------------|
| `AWS_ROLE_ARN` | IAM role ARN for OIDC authentication | Terraform output: `github_actions_role_arn` |
| `SLACK_WEBHOOK_URL` | Slack incoming webhook URL | Slack App Settings |
| `KUBECONFIG` | Kubernetes cluster config (base64 encoded) | `kubectl config view --raw \| base64` |

## Environment-Specific Secrets

Create **Environments** in **Settings → Environments**:

### `staging` Environment

| Secret/Variable | Value |
|-----------------|-------|
| `S3_BUCKET_NAME` | `turbo-fleet-static-staging-ACCOUNT_ID` |
| `CLOUDFRONT_DISTRIBUTION_ID` | From Terraform output |
| `DEPLOY_URL` | `https://DISTRIBUTION_ID.cloudfront.net` |
| `AWS_ROLE_ARN` | `arn:aws:iam::ACCOUNT_ID:role/turbo-fleet-github-actions-staging` |

### `production` Environment

| Secret/Variable | Value |
|-----------------|-------|
| `S3_BUCKET_NAME` | `turbo-fleet-static-production-ACCOUNT_ID` |
| `CLOUDFRONT_DISTRIBUTION_ID` | From Terraform output |
| `DEPLOY_URL` | `https://fleet.turbo.dev` (or your domain) |
| `AWS_ROLE_ARN` | `arn:aws:iam::ACCOUNT_ID:role/turbo-fleet-github-actions-production` |

**Production Environment Protection:**
- ✅ Required reviewers: Add 1-2 approvers
- ✅ Wait timer: 5 minutes (optional)
- ✅ Deployment branches: `main` only

---

## Setup Steps

### 1. Deploy Infrastructure First

```bash
# This creates the IAM role and outputs the ARN
cd sectors/08-aws/infrastructure
terraform init
terraform apply
```

### 2. Copy Terraform Outputs

After `terraform apply`, you'll see outputs like:

```
Outputs:
github_actions_role_arn = "arn:aws:iam::123456789012:role/turbo-fleet-github-actions-staging"
static_bucket_name = "turbo-fleet-static-staging-123456789012"
cloudfront_distribution_id = "E1234567890ABC"
```

### 3. Add to GitHub Secrets

1. Go to repo Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add `AWS_ROLE_ARN` with the value from Terraform
4. Repeat for other secrets

### 4. Create Environments

1. Settings → Environments → New environment
2. Name: `staging`
3. Add environment secrets (S3_BUCKET_NAME, etc.)
4. Repeat for `production` with required reviewers

---

## OIDC Trust Policy

The IAM role created by Terraform has this trust policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:Turbo-the-tech-dev/root:*"
        }
      }
    }
  ]
}
```

**No long-lived credentials needed.** GitHub gets temporary credentials via OIDC.

---

## Verification

After setup, run a test deployment:

```bash
# Trigger workflow
gh workflow run "Deploy Electrician ⚡" --ref main

# Or push to main and watch Actions tab
```

Check:
1. ✅ Workflow starts without credential errors
2. ✅ Terraform plan/apply runs successfully
3. ✅ Files appear in S3 bucket
4. ✅ CloudFront invalidation completes

---

## Troubleshooting

### "Not authorized to perform sts:AssumeRoleWithWebIdentity"

- Check OIDC provider is configured in AWS
- Verify the `sub` claim pattern matches your repo
- Ensure role ARN is correct in secrets

### "Access Denied" on S3

- Verify IAM role has S3 permissions
- Check bucket name matches exactly
- Ensure bucket is in same region as credentials

### CloudFront Invalidation Fails

- Check distribution ID is correct
- Verify IAM role has `cloudfront:CreateInvalidation` permission
- Distribution must be in Enabled state

---

## Security Best Practices

1. **Never commit secrets** - Use GitHub Secrets only
2. **Rotate regularly** - Update Slack webhooks quarterly
3. **Least privilege** - IAM roles should have minimal permissions
4. **Audit logs** - Review Actions logs weekly
5. **Environment protection** - Production requires approval

---

*Last updated: 2026-02-28*
*Marcus Hale approved: "If your secrets are in .env files, you're fired."*
