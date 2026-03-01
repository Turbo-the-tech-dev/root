#!/bin/bash
# 🚨 Imperial Emergency Kill-Switch: Sector 00
# "When the Rebellion exceeds the budget."

echo "🛑 ACTIVATING EMERGENCY KILL-SWITCH..."

# 1. Stop all CloudFront invalidations (if possible, though they usually run to completion)
# 2. Delete the Terraform managed infrastructure
if [ -d "sectors/08-aws/infrastructure" ]; then
    echo "🏗️  Nuking AWS Infrastructure via Terraform..."
    cd sectors/08-aws/infrastructure
    terraform destroy -auto-approve || echo "⚠️  Terraform destroy failed or not available."
fi

# 3. Stop any runaway CI/CD workflows
if command -v gh &> /dev/null; then
    echo "🐙 Cancelling all active GitHub Action runs..."
    gh run list --status in_progress --json databaseId --jq '.[].databaseId' | xargs -I {} gh run cancel {}
fi

# 4. Final Telemetry
echo "🏁 Emergency Protocol Complete. Review AWS console immediately for remaining artifacts."
echo "🔗 AWS Console: https://console.aws.amazon.com/billing/home"
