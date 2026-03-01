# 🔐 Repository Security Checklist

Use this checklist to ensure your repository follows GitHub security best practices.

## ✅ Core Security Features

### Enabled (via GitHub Settings)
- [ ] **Dependabot Alerts** - Notify of vulnerable dependencies
- [ ] **Secret Scanning** - Detect exposed API keys and tokens
- [ ] **Push Protection** - Block commits containing secrets
- [ ] **Code Scanning** - Automated CodeQL analysis
- [ ] **Private Vulnerability Reporting** - Allow private security reports

### Configuration Files
- [x] `SECURITY.md` - Security policy and reporting instructions
- [x] `.github/dependabot.yml` - Automated dependency updates
- [x] `.github/workflows/codeql-analysis.yml` - CodeQL security scanning
- [x] `.github/workflows/secret-scan.yml` - Secret scanning workflow
- [x] `.github/SECRETS_GUIDE.md` - Secrets management documentation

## 📋 Security Feature Status

| Feature | Status | Location |
|---------|--------|----------|
| Dependabot Alerts | ✅ Enabled | `.github/dependabot.yml` |
| Secret Scanning | ✅ Enabled | GitHub Settings + workflows |
| Push Protection | ⬜ Enable | GitHub Settings → Security |
| Code Scanning (CodeQL) | ✅ Enabled | `.github/workflows/codeql-analysis.yml` |
| SECURITY.md | ✅ Exists | `./SECURITY.md` |
| Vulnerability Reporting | ⬜ Enable | GitHub Settings → Security |
| Branch Protection | ⬜ Configure | GitHub Settings → Branches |
| Required Reviews | ⬜ Configure | GitHub Settings → Branches |

## 🛡️ Dependency Management

### Configured Ecosystems

| Ecosystem | Directory | Schedule | Status |
|-----------|-----------|----------|--------|
| npm (root) | `/` | Weekly (Monday) | ✅ |
| npm (DEATHSTAR) | `/DEATHSTAR` | Weekly (Monday) | ✅ |
| npm (Electrician) | `/Electrician-PROMPT-GENIE` | Weekly (Tuesday) | ✅ |
| pip (Python) | `/sovereign-circuit-academy` | Weekly (Wednesday) | ✅ |
| nuget (.NET) | `/Electrical-Core-API` | Weekly (Thursday) | ✅ |
| GitHub Actions | `/` | Weekly (Friday) | ✅ |
| Terraform | `/sectors/08-aws/infrastructure` | Weekly (Friday) | ✅ |
| Docker | `/` | Weekly | ✅ |

## 🔑 Secrets Management

### Required GitHub Secrets

Configure in **Settings → Secrets and variables → Actions**:

| Secret | Purpose | Required For |
|--------|---------|--------------|
| `GEMINI_API_KEY` | Google AI API access | Gemini regeneration |
| `AWS_ROLE_ARN` | AWS OIDC authentication | Terraform, S3 deploy |
| `SLACK_WEBHOOK_URL` | Slack notifications | CI/CD alerts |
| `KUBECONFIG` | Kubernetes access | K8s deployments |

See `.github/SECRETS_GUIDE.md` for setup instructions.

### Best Practices

- [ ] Never commit secrets to the repository
- [ ] Use `.env` files for local development (add to `.gitignore`)
- [ ] Rotate secrets quarterly
- [ ] Use OIDC authentication where possible (no long-lived credentials)
- [ ] Review secret scan alerts weekly

## 🌿 Branch Protection

### Recommended Rules for `main` Branch

Configure in **Settings → Branches → Add branch protection rule**:

- [ ] **Require pull request before merging**
- [ ] **Require approvals** (minimum 1 reviewer)
- [ ] **Dismiss stale reviews on new pushes**
- [ ] **Require status checks to pass** (CI/CD)
- [ ] **Require branches to be up to date** before merging
- [ ] **Include administrators** (apply rules to everyone)
- [ ] **Lock branch** (prevent force pushes)
- [ ] **Restrict who can push** (optional)

## 📊 Security Monitoring

### Weekly Tasks

- [ ] Review Dependabot alerts
- [ ] Check CodeQL scanning results
- [ ] Review secret scan alerts
- [ ] Monitor GitHub Actions workflow runs

### Monthly Tasks

- [ ] Audit repository access/permissions
- [ ] Review and rotate secrets
- [ ] Update dependency baseline
- [ ] Review security policy effectiveness

## 🚨 Incident Response

### If a Secret is Exposed

1. **Immediately rotate the compromised secret** (revoke and generate new)
2. **Check commit history** for when it was introduced
3. **Run `git filter-branch` or BFG** to remove from history
4. **Force push** to update remote repository
5. **Notify affected parties** if credentials were public
6. **Document the incident** for future prevention

### If a Vulnerability is Reported

1. **Acknowledge receipt** within 48 hours
2. **Assess severity** and impact
3. **Develop and test a fix**
4. **Coordinate disclosure** with reporter
5. **Publish security advisory** (if applicable)
6. **Update dependencies** and notify users

## 📚 Resources

- [GitHub Security Features](https://docs.github.com/en/code-security)
- [Dependabot Documentation](https://docs.github.com/en/code-security/dependabot)
- [CodeQL Documentation](https://codeql.github.com/)
- [Secret Scanning](https://docs.github.com/en/code-security/secret-scanning)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

---

**Last Updated:** 2026-02-28  
**Reviewed By:** Security Team
