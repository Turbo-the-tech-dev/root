# GitOps Directory Structure

This directory contains the GitOps configuration for ArgoCD-managed deployments.

## Structure

```
.gitops/
├── applications/
│   ├── electrician-staging.yaml    # Staging ArgoCD Application
│   └── electrician-production.yaml # Production ArgoCD Application
└── app-of-apps/
    └── turbo-fleet.yaml            # App of Apps pattern
```

## Usage

### Sync Staging

```bash
argocd app sync electrician-staging --grpc-web
```

### Sync Production (requires approval)

```bash
argocd app sync electrician-production --grpc-web
```

### Check App Status

```bash
argocd app get electrician-staging --grpc-web
argocd app get electrician-production --grpc-web
```

## Automated Sync

ArgoCD is configured to auto-sync on git push for staging.
Production requires manual approval in the ArgoCD UI or via CLI.
