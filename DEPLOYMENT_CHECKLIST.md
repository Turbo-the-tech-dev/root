# Marcus Hale's Deployment Checklist

> "If you can't check all these boxes, you're not ready to deploy."

---

## Pre-Deployment Checklist

### Infrastructure as Code

- [ ] Terraform state backend configured (S3 + DynamoDB locking)
- [ ] All AWS resources defined in code (no ClickOps)
- [ ] `terraform.tfvars` for each environment
- [ ] Destruction protection enabled for production
- [ ] IAM roles use OIDC for GitHub Actions (no long-lived credentials)

### Container Security

- [ ] Multi-stage Docker builds (minimal image size)
- [ ] Running as non-root user
- [ ] Read-only root filesystem
- [ ] No secrets in Docker images
- [ ] Trivy scan passes (no CRITICAL/HIGH vulnerabilities)

### Kubernetes Configuration

- [ ] Resource requests AND limits defined
- [ ] Liveness and readiness probes configured
- [ ] PodDisruptionBudget set
- [ ] NetworkPolicy restricts traffic
- [ ] PodSecurityContext hardened
- [ ] ServiceAccount with minimal permissions
- [ ] TopologySpreadConstraints for HA

### Secrets Management

- [ ] Secrets in AWS Secrets Manager (not Git)
- [ ] External Secrets Operator configured
- [ ] Secrets rotated regularly
- [ ] No `.env` files committed

### CI/CD Pipeline

- [ ] Lint passes
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Security scan passes
- [ ] Image built and pushed
- [ ] Staging deployment successful
- [ ] Smoke tests pass against staging

### Observability

- [ ] Prometheus scraping configured
- [ ] Grafana dashboards created
- [ ] Alertmanager routes configured
- [ ] PagerDuty integration working
- [ ] Slack notifications working

---

## Deployment Runbook

### Staging Deployment

```bash
# 1. Push to main branch
git push origin feature-branch:main

# 2. Monitor GitHub Actions
# https://github.com/Turbo-the-tech-dev/root/actions

# 3. Verify ArgoCD sync
argocd app sync electrician-staging --grpc-web

# 4. Check deployment status
argocd app wait electrician-staging --health --grpc-web

# 5. Run smoke tests
make test-smoke ENV=staging
```

### Production Deployment

```bash
# 1. Verify staging is healthy
argocd app get electrician-staging --grpc-web

# 2. Approve production deployment in ArgoCD UI
# OR via CLI:
argocd app sync electrician-production --grpc-web

# 3. Monitor canary rollout
argocd rollout get electrician-canary -n turbo-fleet-production

# 4. Watch metrics
# https://grafana.fleet.turbo.dev/d/canary-analysis

# 5. If canary fails, automatic rollback triggers
# If canary succeeds, full rollout completes automatically
```

### Emergency Rollback

```bash
# 1. Identify last known good commit
git log --oneline -10

# 2. Revert in Git (triggers ArgoCD sync)
git revert <bad-commit>
git push origin main

# 3. Or force sync to specific revision
argocd app set electrician-production \
  --revision abc123 \
  --grpc-web
argocd app sync electrician-production --grpc-web

# 4. For immediate rollback, use kubectl
kubectl rollout undo deployment/prod-electrician \
  -n turbo-fleet-production
```

---

## Monitoring Checklist

### Dashboards

| Dashboard | URL | Purpose |
|-----------|-----|---------|
| Cluster Health | `/d/cluster` | Overall cluster status |
| Pod Monitoring | `/d/pods` | Per-pod metrics |
| Application | `/d/app` | Business metrics |

### Alerts

| Alert | Severity | Channel | Action |
|-------|----------|---------|--------|
| PodCrashLooping | Critical | PagerDuty + Slack | Investigate immediately |
| PodNotReady | Warning | Slack | Monitor, may self-heal |
| HighMemoryUsage | Warning | Slack | Scale up or optimize |
| HighCPUUsage | Warning | Slack | Scale up or optimize |
| DeploymentReplicasMismatch | Warning | Slack | Check deployment status |
| PVCCritical | Critical | PagerDuty | Free up storage |

### Runbooks

Each alert should link to a runbook with:
1. Symptoms
2. Common causes
3. Troubleshooting steps
4. Escalation path

---

## Post-Deployment Verification

- [ ] All pods Running and Ready
- [ ] HPA showing correct metrics
- [ ] No error logs in last 15 minutes
- [ ] Latency p99 < 500ms
- [ ] Error rate < 1%
- [ ] Canaries promoted to 100%
- [ ] Smoke tests passing
- [ ] Dashboards updating
- [ ] Alerts firing correctly (or not firing)

---

## Sign-Off

| Role | Name | Date |
|------|------|------|
| DevOps | Marcus Hale | _ |
| Developer | _ | _ |
| QA | _ | _ |

---

> **Remember:** If you're SSH-ing into production to fix something, we've already failed. Fix it in code, commit, and let GitOps handle it.
>
> — M.H.
