# CloudForge — Deployment Guide

## 1. Purpose

This document describes the planned deployment process for CloudForge.

The first implementation will use a local Docker deployment simulation.
AWS deployment will be considered only after local testing and cost review.

## 2. Deployment Architecture

The planned deployment lifecycle is:

1. Developer updates application code.
2. GitHub Actions runs Continuous Integration.
3. Python tests and Terraform validation execute.
4. Docker builds the application image.
5. The image is tagged with a version.
6. Production deployment requires manual approval.
7. A local deployment script starts the Docker container.
8. Application health checks verify successful deployment.
9. Logs are inspected and rollback is available if deployment fails.

## 3. Local Deployment Environment

The local environment uses:

- WSL2 Ubuntu
- Docker Desktop
- Docker Engine
- Python Flask application
- Gunicorn application server

No AWS infrastructure is required for this stage.

## 4. Container Deployment Requirements

The deployment process should:

- Use a clearly identifiable Docker image tag.
- Avoid exposing the application on all host network interfaces.
- Run the container as a non-root user.
- Apply resource limits.
- Drop unnecessary Linux capabilities.
- Enable a container health check.
- Avoid automatic restart policies during controlled testing.

## 5. Health Verification

After deployment, verify:

- The Docker container is running.
- The container health status is healthy.
- The application root endpoint responds successfully.
- The health endpoint returns HTTP 200.
- Application logs do not show startup errors.

## 6. Rollback Strategy

The deployment process should retain the previous working image.

If a new deployment fails:

1. Stop the failed container.
2. Start the previous known-good image.
3. Verify the restored container health.
4. Inspect logs to identify the failure.

The rollback procedure must not delete the previous working image.

## 7. Security Requirements

- Never store credentials in source code.
- Do not expose the application publicly during local testing.
- Run containers with least privilege.
- Use read-only container filesystems where practical.
- Apply CPU, memory and process limits.
- Do not run containers in privileged mode.

## 8. AWS Migration Plan

After local deployment is verified, the architecture may be extended to use:

- Amazon ECR for container image storage.
- GitHub Actions OIDC for AWS authentication.
- Terraform for AWS infrastructure management.
- An AWS container service for application deployment.

All AWS resources require a cost assessment and explicit approval before creation.

## 9. Cost Control

The total AWS practice budget is limited to ₹500.

Local Docker testing does not require AWS resources.

Before any AWS deployment:

- Review expected resource costs.
- Check AWS Billing and Cost Explorer.
- Check available credits.
- Obtain explicit approval.
- Plan resource cleanup.

## 10. Current Status

- Local Docker image build: completed.
- Container security configuration: tested.
- Application health checks: tested.
- GitHub Actions CI: verified.
- Production approval gate: verified.
- Automated local deployment script: planned.
- Rollback automation: planned.
- AWS deployment: not started.
