# =============================================================================
# Imperial Shell Configuration
# Add to ~/.bashrc or ~/.zshrc for global Imperial Command access
# =============================================================================

# Imperial Sector Search Alias
alias s='bash ~/Imperial/root/scripts/sector-search.sh'

# Quick sector navigation
alias s08='s 08 -j'  # Jump to AWS
alias s17='s 17 -j'  # Jump to Flutter
alias s19='s 19 -j'  # Jump to Expo
alias s06='s 06 -j'  # Jump to Firestore
alias s15='s 15 -j'  # Jump to Vader (Security)

# Vader-Gate security scans
alias vader06='s 06 -v'  # Scan Firestore for secrets
alias vader08='s 08 -v'  # Scan AWS for secrets

# Performance benchmark
alias s-bench='s -b'

# Deploy to RHEL
alias s-deploy='s -d'

# Imperial Push shortcuts
alias push-imperial='cd ~/Imperial/root && git add -A && git commit -m "feat: Imperial update" && git push origin master'

# Quick sector status
alias sectors='ls -la ~/Imperial/root/sectors/'

# Makefile shortcuts (when in root)
alias tf-apply='make tf-apply'
alias tf-plan='make tf-plan'
alias k8s-apply='make k8s-apply-staging'
