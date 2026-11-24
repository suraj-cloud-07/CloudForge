# CloudForge Setup Guide

## 1. Project Overview

CloudForge is a hands-on DevOps and cloud engineering project demonstrating application development, automated testing, containerization, infrastructure validation, and controlled deployment.

This guide explains how to prepare the local development environment and run the project's existing validation workflow.

## 2. Prerequisites

Install or prepare the following tools:

- **Windows with WSL2:** Provides the Linux development environment.
- **Ubuntu:** Linux distribution used for project development.
- **Git:** Version control and GitHub integration.
- **Python 3.14:** Runs the Flask application and automated tests.
- **Docker Desktop:** Builds and runs application containers.
- **Terraform:** Formats and validates infrastructure configuration.
- **GitHub account:** Hosts the repository and GitHub Actions workflow.

Docker Desktop must be running, with WSL integration enabled for the Ubuntu distribution.

## 3. Clone the Repository

Clone the project using Git:

```bash
git clone git@github.com:suraj-cloud-07/CloudForge.git
```

Enter the project directory:

```bash
cd CloudForge
```

## 4. Set Up Python

Create a virtual environment:

```bash
python3 -m venv .venv
```

Activate it:

```bash
source .venv/bin/activate
```

Install development dependencies:

```bash
python -m pip install -r requirements-dev.txt
```

The development requirements include Flask, Gunicorn, and pytest.

## 5. Run Application Tests

Run the automated tests:

```bash
pytest -v
```

The tests verify the application's home, health, and information endpoints.

## 6. Build the Docker Image

Build the application image from the project root:

```bash
docker build -t cloudforge:local .
```

Verify that the image exists:

```bash
docker images cloudforge
```

Docker Desktop must be running before executing Docker commands.

## 7. Validate Terraform Configuration

Move into the Terraform configuration directory:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init -backend=false
```

Check formatting:

```bash
terraform fmt -check -recursive
```

Validate the configuration:

```bash
terraform validate
```

Return to the project root:

```bash
cd ..
```

**Important:** Terraform validation and planning do not create AWS infrastructure. Do not run `terraform apply` as part of this local setup guide.

## 8. Verify GitHub Actions

The repository includes a GitHub Actions workflow at:

`.github/workflows/ci.yml`

The workflow performs:

- Python dependency installation
- Python syntax checks
- Dependency consistency checks
- Automated pytest execution
- Terraform formatting and validation
- Docker image build
- Controlled production approval checkpoint

Pushes to the `main` branch trigger the workflow. The production job waits for the configured GitHub environment approval.

The current production job is an approval simulation and does not deploy to AWS.

## 9. Cost and Safety

CloudForge prioritizes local testing and cost-aware development.

- Local Python tests do not create AWS resources.
- Local Docker builds do not create AWS resources.
- Terraform formatting and validation do not create AWS resources.
- No AWS infrastructure is required to complete this setup.

Review expected charges and obtain explicit approval before any future billable AWS activity.

## 10. Current Project Status

The local application, automated tests, Docker build, Terraform validation, GitHub Actions pipeline, and controlled approval checkpoint are implemented.

AWS infrastructure deployment has not started.
