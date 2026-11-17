# CloudForge — System Architecture

## 1. Architecture Overview

CloudForge is an automated cloud infrastructure deployment
and management platform.

It uses Infrastructure as Code (IaC), containerization,
Continuous Integration (CI), and controlled Continuous
Delivery (CD) to deploy and manage applications on AWS.

## 2. High-Level Architecture

```text
Developer
    |
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    v
Continuous Integration (CI)
    |
    +----> Build Application
    |
    +----> Run Automated Tests
    |
    +----> Build Docker Image
    |
    v
Deployment Approval Gate
    |
    v
Continuous Delivery (CD)
    |
    +----> Terraform
    |        |
    |        v
    |      AWS Infrastructure
    |
    +----> Deploy Docker Container
             |
             v
        Running Application
```

## 3. Core Components

### 3.1 Git and GitHub

Git tracks changes to the project source code.
GitHub hosts the repository and provides version control collaboration.

### 3.2 GitHub Actions

GitHub Actions executes automated workflows when defined events occur,
such as pushing code or opening a pull request.

It will be used to:
- Install dependencies.
- Run automated tests.
- Build the application.
- Build the Docker image.

### 3.3 Terraform

Terraform is an Infrastructure as Code (IaC) tool.

It defines and manages cloud infrastructure using configuration files.
CloudForge will use Terraform to provision AWS resources.

### 3.4 Docker

Docker packages the application and its dependencies into an image.

A container runs an instance of that image in an isolated environment.

### 3.5 AWS

AWS provides the cloud infrastructure where the application
and supporting services will run.
## 4. Deployment Control

CloudForge will use a controlled deployment process.

### 4.1 Continuous Integration (CI)

CI runs automatically when code changes are pushed
to the GitHub repository.

The CI workflow will:
- Install application dependencies.
- Execute automated tests.
- Build the Docker image.
- Report whether the checks passed or failed.

### 4.2 Continuous Delivery (CD)

CD prepares verified application changes for deployment.

CloudForge will require an approval step before
deploying to the production environment.

### 4.3 Deployment Approval Gate

The deployment approval gate prevents the production
deployment job from proceeding until an authorized
reviewer approves it.

This separates successful testing from permission
to deploy.

A successful CI workflow alone will not authorize
a production deployment.
## 5. Cost Management and Security Principles

### 5.1 Cost Management

CloudForge will follow a cost-conscious cloud deployment strategy.

- Review estimated AWS costs before creating resources.
- Prefer local testing and free alternatives where possible.
- Avoid unnecessary running infrastructure.
- Monitor AWS Billing and Cost Explorer.
- Remove temporary resources after approved lab sessions.

### 5.2 Security Principles

CloudForge will follow these security practices:

- Apply the principle of least privilege to IAM permissions.
- Never commit AWS credentials, passwords, or secrets.
- Store sensitive configuration outside source control.
- Review infrastructure changes before deployment.
- Require approval before production deployment.

### 5.3 Budget Control

The project will follow a maximum AWS practice budget of ₹500.

No potentially billable AWS resources will be created
without reviewing expected costs and receiving approval.
## 6. Project Status

CloudForge is currently under development.

### 6.1 Completed

- Created the GitHub repository.
- Initialized the local Git repository.
- Added project documentation.
- Documented the initial system architecture.
- Defined cost management and security principles.

### 6.2 Planned

- Develop the application.
- Create and test the Docker configuration.
- Implement Terraform infrastructure.
- Configure GitHub Actions CI workflows.
- Implement controlled deployment with approval.
- Test the complete deployment process.

### 6.3 Deployment Status

No AWS infrastructure has been deployed as part of
the CloudForge project so far.

AWS deployment will begin only after local testing,
review, and cost assessment.
