# CloudForge — Deployment Guide

## 1. Purpose

This document describes the CloudForge deployment process.

The current implementation uses local Docker deployment simulations to test deployment safety, health checks, and rollback protection.

AWS deployment will be considered only after local testing and cost review.

## 2. Deployment Architecture

The deployment lifecycle is:

1. Developer updates application code.
2. GitHub Actions runs Continuous Integration.
3. Python tests and Terraform validation execute.
4. Docker builds the application image.
5. The image is tagged with a version.
6. Production deployment requires manual approval.
7. A deployment script starts the candidate container.
8. Container and application health checks verify the candidate.
9. The previous known-good version remains available during candidate verification.
10. A failed candidate is removed without deleting the previous version.

The current deployment workflow is a local blue-green deployment simulation. It does not yet perform production traffic switching.

## 3. Local Deployment Environment

The local environment uses:

- WSL2 Ubuntu
- Docker Desktop
- Docker Engine
- Python Flask application
- Gunicorn application server
- Bash deployment scripts

No AWS infrastructure is required for this stage.

## 4. Container Deployment Requirements

The deployment process should:

- Use a clearly identifiable Docker image tag.
- Bind the application to localhost during local testing.
- Run the container as a non-root user.
- Apply memory, CPU, and process limits.
- Drop unnecessary Linux capabilities.
- Prevent privilege escalation.
- Use a read-only container filesystem where practical.
- Provide a container health check.
- Avoid automatic restart policies during controlled testing.

## 5. Health Verification

The deployment process checks:

- Whether the Docker container starts successfully.
- Whether the container health status becomes healthy.
- Whether the application health endpoint returns HTTP 200.
- Whether the known-good version remains healthy.

The application also provides:

- `/` — application information.
- `/health` — application health status.
- `/api/info` — application version and environment information.

## 6. Local Deployment and Rollback Protection

CloudForge includes two deployment approaches:

### Local deployment

`scripts/deploy-local.sh` starts a versioned container with security restrictions and verifies its health.

The previous containers and images are preserved.

### Candidate deployment with rollback protection

`scripts/deploy-with-rollback.sh` accepts:

- Candidate image tag.
- Known-good rollback port.
- Candidate deployment port.

The script:

1. Checks that the Docker Engine is available.
2. Verifies that the candidate image exists.
3. Checks that the known-good rollback endpoint is healthy.
4. Starts the candidate container on a separate localhost port.
5. Waits for the candidate container health check.
6. Verifies the candidate application health endpoint.
7. Keeps the candidate if both health checks pass.
8. Removes only the candidate if deployment fails.
9. Checks that the known-good version remains healthy.

The script also uses shell traps to clean up a candidate container after an interruption such as Ctrl+C or SIGTERM.

SIGKILL cannot be caught by shell traps, so cleanup cannot be guaranteed after that signal or an abrupt system shutdown.

**Important limitation:** This is rollback protection, not a complete production traffic-switching implementation. The known-good version remains available on its existing port; the script does not automatically redirect traffic to it.

Previous working containers and images must not be deleted as part of candidate failure cleanup.

## 7. Deployment Security

- Never store credentials in source code.
- Do not expose the application publicly during local testing.
- Run containers with least privilege.
- Use a read-only root filesystem where practical.
- Apply CPU, memory, and process limits.
- Drop unnecessary Linux capabilities.
- Enable `no-new-privileges`.
- Avoid privileged containers.

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
- Automated local deployment script: completed and tested.
- Local deployment: `cloudforge:1.2` successfully deployed and verified on port `5002`.
- Candidate deployment with rollback protection: implemented and tested.
- Candidate cleanup after failed health checks: tested.
- Candidate cleanup after Ctrl+C interruption: tested.
- Known-good version health after candidate failure: verified.
- AWS deployment: not started.
