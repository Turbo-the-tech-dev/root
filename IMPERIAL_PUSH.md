# ⚡ The Imperial Push — 8-Hour Sprint Runbook

> "Manual is the enemy of scale. Automate it or it didn't happen." — M.H.

---

## 📋 Pre-Sprint Checklist

**Before Hour 0:**

- [ ] Terraform deployed (`make tf-apply`)
- [ ] GitHub Secrets configured (see `SECRETS_GUIDE.md`)
- [ ] Flutter SDK 3.19+ installed locally
- [ ] AWS CLI configured with OIDC role
- [ ] Coffee supply secured (minimum 4 pods)

---

## ⏰ Hour-by-Hour Sprint Plan

### Hour 0-1: Infrastructure Bootstrap

```bash
# 1. Initialize and deploy infrastructure
cd sectors/08-aws/infrastructure
terraform init
terraform apply -var-file=terraform.tfvars

# 2. Capture outputs for GitHub Secrets
terraform output -json > ../outputs.json

# 3. Configure GitHub Secrets (manual step)
# See SECRETS_GUIDE.md
```

**Success Criteria:**
- ✅ S3 bucket exists
- ✅ CloudFront distribution is Deployed
- ✅ IAM role ARN captured

---

### Hour 1-3: Flutter Build Pipeline

```bash
# 1. Verify Flutter builds locally
cd Electrician-PROMPT-GENIE
flutter pub get
flutter test
flutter build web --release

# 2. Test the build
cd build/web
python -m http.server 8080
# Open http://localhost:8080

# 3. Commit and push
git add .
git commit -m "feat: Imperial Push ready"
git push origin main
```

**Success Criteria:**
- ✅ Tests pass
- ✅ Web build completes
- ✅ Local server serves app

---

### Hour 3-5: CI/CD Integration

```bash
# 1. Watch GitHub Actions
# https://github.com/Turbo-the-tech-dev/root/actions

# 2. Verify workflow runs:
#    - Terraform Plan ✓
#    - Flutter Build ✓
#    - Deploy to S3 ✓
#    - CloudFront Invalidation ✓

# 3. Check deployment
curl -I https://YOUR_DISTRIBUTION_ID.cloudfront.net
```

**Success Criteria:**
- ✅ All workflow jobs green
- ✅ App accessible via CloudFront URL
- ✅ Smoke test passes

---

### Hour 5-6: Riverpod + Firestore Integration

```dart
// lib/src/providers/electrician_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final interviewQuestionsProvider = StreamProvider<List<Question>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
    .collection('interview-questions')
    .where('nec_compliant', isEqualTo: true)
    .snapshots()
    .map((snapshot) => snapshot.docs
      .map((doc) => Question.fromFirestore(doc))
      .toList()
    );
});
```

**Success Criteria:**
- ✅ Firestore stream connected
- ✅ Questions load dynamically
- ✅ No hardcoded data

---

### Hour 6-7: Canary Rollout (Production)

```bash
# 1. Deploy to staging first
gh workflow run "Deploy Electrician ⚡" \
  --field environment=staging

# 2. Verify staging
curl -I https://staging.fleet.turbo.dev

# 3. Deploy to production (canary)
gh workflow run "Deploy Electrician ⚡" \
  --field environment=production

# 4. Monitor canary analysis
kubectl argo rollouts get rollout prod-electrician-canary -n turbo-fleet-production -w
```

**Success Criteria:**
- ✅ Staging healthy
- ✅ Canary starts at 10%
- ✅ Metrics within threshold

---

### Hour 7-8: Final Verification

```bash
# 1. Full rollout complete
kubectl argo rollouts get rollout prod-electrician-canary -n turbo-fleet-production

# 2. Check Grafana dashboard
# https://grafana.fleet.turbo.dev/d/app

# 3. Verify no alerts in Alertmanager
# https://alertmanager.fleet.turbo.dev

# 4. Smoke test production
curl -f https://fleet.turbo.dev || exit 1

# 5. Claim the green square
git status  # Should be clean
```

**Success Criteria:**
- ✅ 100% rollout complete
- ✅ No alerts firing
- ✅ GitHub green square claimed
- ✅ Coffee consumption: 4+ pods

---

## 🚨 Emergency Procedures

### Rollback to Last Known Good

```bash
# 1. Find last good commit
git log --oneline -10

# 2. Revert
git revert HEAD
git push origin main

# 3. Or force rollback via ArgoCD
argocd app rollback electrician-production <revision>
```

### Infrastructure Emergency

```bash
# Nuke and rebuild (staging only!)
./sectors/08-aws/imperial-purge.sh staging
./sectors/08-aws/imperial-arsenal.sh staging
```

### Pipeline Stuck

```bash
# Cancel and re-run
gh run cancel --repo Turbo-the-tech-dev/root <run-id>
gh workflow run "Deploy Electrician ⚡" --ref main
```

---

## 📊 Post-Sprint Metrics

| Metric | Target | Actual |
|--------|--------|--------|
| Deploy Time | < 5 min | _ |
| Test Pass Rate | 100% | _ |
| Error Rate | < 1% | _ |
| Latency p99 | < 500ms | _ |
| Coffee Consumed | 4+ pods | _ |

---

## ✅ Sign-Off

| Role | Name | Status |
|------|------|--------|
| DevOps | Marcus Hale | ☕ Caffeinated |
| Developer | _ | _ |
| QA | _ | _ |

---

> **Remember:** If you're doing anything manually after Hour 8, you've already failed. The pipeline is the product.
>
> **Now go claim those green squares.** ⚡
