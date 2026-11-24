# CloudForge

CloudForge is a hands-on DevOps and cloud engineering project demonstrating how to build, test, containerize, and deploy an application through controlled automation.

## Objectives

- Build and test a containerized application.
- Automate quality checks through GitHub Actions.
- Validate infrastructure configuration using Terraform.
- Implement controlled production deployment approval.
- Simulate safe deployments with rollback protection.
- Apply container security and resource limits.
- Follow cost-aware cloud infrastructure practices.

## Technology Stack

| Technology | Purpose |
|---|---|
| Python and Flask | Application development |
| Gunicorn | Production application server |
| Docker | Application containerization |
| Terraform | Infrastructure as Code |
| Git and GitHub | Version control |
| GitHub Actions | CI/CD automation |
| Bash | Deployment automation |
| Linux (Ubuntu/WSL2) | Development environment |
| AWS | Planned cloud deployment platform |

## Architecture

1. Developers push application changes to GitHub.
2. GitHub Actions runs automated tests and quality checks.
3. Terraform configuration is formatted and validated.
4. Docker builds the application image.
5. Production deployment requires manual approval.
6. Local scripts demonstrate deployment health checks and rollback protection.

## Project Structure

```text
CloudForge/
├── .github/
│   └── workflows/
├── application/
├── architecture/
├── docker/
├── docs/
├── screenshots/
├── scripts/
├── terraform/
└── tests/
    └── docker/
```

## Deployment and Security

- Containerized application using Docker and Gunicorn.
- Non-root container execution.
- Read-only root filesystem.
- CPU, memory, and process limits.
- Dropped Linux capabilities and no-new-privileges.
- Local deployment health checks and rollback protection.
- Manual production approval checkpoint in GitHub Actions.

## Cost Management

CloudForge prioritizes local testing and cost-aware infrastructure practices.

AWS resources will only be created after reviewing expected costs and receiving explicit approval. The project has a total AWS practice budget limit of ₹500 for Day 29 and the final project.

Billing, Cost Explorer, and remaining credits will be checked regularly. Resources will be cleaned up after approved lab sessions.

## Current Project Status

- Flask application and automated tests implemented.
- Docker image built and tested locally.
- GitHub Actions CI pipeline implemented.
- Terraform configuration validated.
- Production approval checkpoint configured.
- Local deployment and rollback-protection scripts implemented and tested.
- AWS infrastructure deployment has not started.
