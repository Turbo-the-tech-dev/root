# Turbo Fleet - GitOps Quick Start

## Prerequisites

1. **ArgoCD installed** on your Kubernetes cluster
2. **kubectl configured** to access the cluster
3. **GitHub access** to Turbo-the-tech-dev/root repository

---

## Initial Setup

### 1. Create ArgoCD Project

```bash
argocd proj create turbo-fleet \
  --src https://github.com/Turbo-the-tech-dev/root.git \
  --dest https://kubernetes.default.svc,* \
  --allow-cluster-resources true \
  --grpc-web
```

### 2. Add Git Repository to ArgoCD

```bash
argocd repo add https://github.com/Turbo-the-tech-dev/root.git \
  --username <your-username> \
  --password <your-token> \
  --grpc-web
```

### 3. Deploy App of Apps

```bash
# Apply the ApplicationSet
kubectl apply -f .gitops/app-of-apps/turbo-fleet.yaml

# Or create manually:
argocd app create turbo-fleet \
  --repo https://github.com/Turbo-the-tech-dev/root.git \
  --path .gitops/app-of-apps \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace argocd \
  --sync-policy automated \
  --auto-prune \
  --grpc-web
```

---

## Daily Operations

### Check Application Status

```bash
# List all applications
argocd app list --grpc-web

# Get specific app status
argocd app get electrician-staging --grpc-web
argocd app get electrician-production --grpc-web
```

### Sync Applications

```bash
# Staging (auto-sync enabled, but manual trigger available)
argocd app sync electrician-staging --grpc-web

# Production (requires manual approval)
argocd app sync electrician-production --grpc-web
```

### Wait for Health

```bash
argocd app wait electrician-staging --health --grpc-web
```

### View Resources

```bash
# Show all resources managed by an application
argocd app resources electrician-staging --grpc-web
```

### Rollback

```bash
# List revision history
argocd app history electrician-staging --grpc-web

# Rollback to revision
argocd app rollback electrician-staging <revision> --grpc-web
```

---

## Monitoring

### Grafana Dashboards

Access Grafana at: `https://grafana.fleet.turbo.dev`

| Dashboard | Purpose |
|-----------|---------|
| Cluster | Overall cluster health |
| Pods | Per-pod metrics |
| Application | Business metrics |

### Alerts

| Channel | Purpose |
|---------|---------|
| `#incidents` | Critical alerts (PagerDuty) |
| `#ops-warnings` | Warning alerts |
| `#ops-info` | Informational alerts |

---

## Troubleshooting

### Application Out of Sync

```bash
# Check diff
argocd app diff electrician-staging --grpc-web

# Force refresh
argocd app get electrician-staging --refresh --grpc-web

# Sync with prune
argocd app sync electrician-staging --prune --grpc-web
```

### Deployment Stuck

```bash
# Check rollout status
kubectl rollout status deployment/staging-electrician \
  -n turbo-fleet-staging

# View pod events
kubectl get events -n turbo-fleet-staging --sort-by='.lastTimestamp'

# Check pod logs
kubectl logs -n turbo-fleet-staging -l app.kubernetes.io/name=electrician
```

### ArgoCD Issues

```bash
# Check ArgoCD controller logs
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-application-controller

# Restart ArgoCD controller
kubectl rollout restart deployment -n argocd argocd-application-controller
```

---

## Security

### RBAC

ArgoCD is configured with:
- Read-only access for developers
- Write access for DevOps team
- Production sync requires admin approval

### Secrets

- All secrets managed via External Secrets Operator
- AWS Secrets Manager is the source of truth
- No secrets stored in Git

---

## Adding New Applications

1. Create Kustomize overlay in `k8s/overlays/<app>-<env>/`
2. Add Application manifest in `.gitops/applications/`
3. Commit and push
4. ArgoCD auto-discovers and deploys

---

## Support

| Issue | Contact |
|-------|---------|
| ArgoCD issues | DevOps Team |
| Application issues | Development Team |
| Infrastructure issues | Marcus Hale |

---

> "GitOps is not a tool. It's a way of life."
> — M.H.
