# Terraform Variables - Turbo Fleet Infrastructure
# Override these with terraform.tfvars or environment variables

# Environment Configuration
environment = "staging"

# AWS Region
aws_region = "us-east-1"

# Custom Domain (optional - leave empty for CloudFront default domain)
domain_name = ""

# Route53 Hosted Zone ID (required if using custom domain)
hosted_zone_id = ""

# Destruction Protection (set to false for staging to allow easy cleanup)
enable_destruction_protection = false
