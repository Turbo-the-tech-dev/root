# Turbo Fleet - Makefile
# Common operations for local development and CI/CD
# =============================================================================

.PHONY: help install test build lint clean docker-build docker-run tf-init tf-plan tf-apply tf-destroy k8s-apply k8s-delete argocd-sync

# Default target
help:
	@echo "Turbo Fleet - Available Commands"
	@echo "================================"
	@echo ""
	@echo "Development:"
	@echo "  install         Install all workspace dependencies"
	@echo "  test            Run all tests"
	@echo "  lint            Run all linters"
	@echo "  build           Build all workspaces"
	@echo "  clean           Clean build artifacts"
	@echo ""
	@echo "Docker:"
	@echo "  docker-build    Build Docker images for all workspaces"
	@echo "  docker-run      Run containers locally"
	@echo "  docker-clean    Remove all Turbo Fleet containers"
	@echo ""
	@echo "Infrastructure (Terraform):"
	@echo "  tf-init         Initialize Terraform"
	@echo "  tf-plan         Show Terraform plan"
	@echo "  tf-apply        Apply Terraform changes"
	@echo "  tf-destroy      Destroy all infrastructure"
	@echo "  tf-validate     Validate Terraform configuration"
	@echo ""
	@echo "Environment:"
	@echo "  ENV             Environment name (default: staging)"
	@echo ""

# =============================================================================
# Development
# =============================================================================

install:
	@echo "Installing dependencies..."
	npm install --workspaces --include=dev

test:
	@echo "Running tests..."
	npm run test

lint:
	@echo "Running linters..."
	npm run lint

build:
	@echo "Building all workspaces..."
	npm run build

clean:
	@echo "Cleaning build artifacts..."
	find . -type d -name "node_modules" -prune -o -type d -name "dist" -exec rm -rf {} \;
	find . -type d -name "build" -exec rm -rf {} \;
	find . -type d -name ".next" -exec rm -rf {} \;
	find . -type d -name "coverage" -exec rm -rf {} \;

# =============================================================================
# Docker
# =============================================================================

docker-build:
	@echo "Building Docker images..."
	docker build -t turbo-fleet/electrician:latest ./Electrician-PROMPT-GENIE
	docker build -t turbo-fleet/deathstar:latest ./DEATHSTAR

docker-run:
	@echo "Running containers..."
	docker-compose up -d

docker-clean:
	@echo "Removing Turbo Fleet containers..."
	docker ps -a --filter "name=turbo-fleet" --format "{{.ID}}" | xargs -r docker rm -f
	docker images turbo-fleet/* --format "{{.ID}}" | xargs -r docker rmi -f

# =============================================================================
# Terraform (Infrastructure)
# =============================================================================

TF_DIR = sectors/08-aws/infrastructure
TF_VARS = $(TF_DIR)/terraform.tfvars

ifdef ENV
	ifeq ($(ENV),production)
		TF_VARS = $(TF_DIR)/terraform.tfvars.production
	endif
endif

tf-init:
	@echo "Initializing Terraform..."
	cd $(TF_DIR) && terraform init

tf-plan:
	@echo "Creating Terraform plan..."
	cd $(TF_DIR) && terraform plan -var-file=$(TF_VARS) -out=tfplan

tf-apply:
	@echo "Applying Terraform changes..."
	cd $(TF_DIR) && terraform apply tfplan

tf-destroy:
	@echo "WARNING: This will destroy all infrastructure!"
	@echo "Environment: $(or $(ENV),staging)"
	read -p "Type 'destroy' to confirm: " confirm && \
	if [ "$$confirm" = "destroy" ]; then \
		cd $(TF_DIR) && terraform destroy -var-file=$(TF_VARS); \
	else \
		echo "Destruction cancelled"; \
	fi

tf-validate:
	@echo "Validating Terraform..."
	cd $(TF_DIR) && terraform fmt -check -recursive && terraform validate

tf-output:
	@echo "Terraform Outputs:"
	cd $(TF_DIR) && terraform output -no-color

# =============================================================================
# CI/CD Helpers
# =============================================================================

ci-local:
	@echo "Running local CI simulation..."
	$(MAKE) lint
	$(MAKE) test
	$(MAKE) build
	$(MAKE) docker-build
	$(MAKE) tf-validate

pr-check:
	@echo "Running PR checks..."
	$(MAKE) ci-local
	@echo "All checks passed!"

# =============================================================================
# Utilities
# =============================================================================

shell:
	@echo "Opening shell in Electrician workspace..."
	cd Electrician-PROMPT-GENIE && npm run shell || /bin/sh

logs:
	@echo "Tailing logs..."
	tail -f logs/*.log 2>/dev/null || echo "No logs available"

# =============================================================================
# Kubernetes
# =============================================================================

K8S_BASE = k8s/base
K8S_STAGING = k8s/overlays/staging
K8S_PRODUCTION = k8s/overlays/production

k8s-diff-staging:
	@echo "Showing diff for staging..."
	kubectl diff -k $(K8S_STAGING)

k8s-diff-production:
	@echo "Showing diff for production..."
	kubectl diff -k $(K8S_PRODUCTION)

k8s-apply-staging:
	@echo "Applying staging configuration..."
	kubectl apply -k $(K8S_STAGING)

k8s-apply-production:
	@echo "Applying production configuration..."
	kubectl apply -k $(K8S_PRODUCTION)

k8s-delete-staging:
	@echo "Deleting staging resources..."
	kubectl delete -k $(K8S_STAGING) --ignore-not-found

k8s-delete-production:
	@echo "WARNING: This will delete production resources!"
	read -p "Type 'delete' to confirm: " confirm && \
	if [ "$$confirm" = "delete" ]; then \
		kubectl delete -k $(K8S_PRODUCTION) --ignore-not-found; \
	else \
		echo "Deletion cancelled"; \
	fi

k8s-pods:
	@echo "Listing pods..."
	kubectl get pods -n turbo-fleet-staging -o wide
	kubectl get pods -n turbo-fleet-production -o wide

k8s-logs:
	@echo "Tailing logs..."
	kubectl logs -n turbo-fleet-staging -l app.kubernetes.io/name=electrician -f

# =============================================================================
# ArgoCD
# =============================================================================

argocd-sync-staging:
	@echo "Syncing staging application..."
	argocd app sync electrician-staging --grpc-web

argocd-sync-production:
	@echo "Syncing production application..."
	argocd app sync electrician-production --grpc-web

argocd-status:
	@echo "ArgoCD Application Status:"
	argocd app list --grpc-web
	argocd app get electrician-staging --grpc-web
	argocd app get electrician-production --grpc-web

argocd-health:
	@echo "Waiting for applications to be healthy..."
	argocd app wait electrician-staging --health --grpc-web
	argocd app wait electrician-production --health --grpc-web
