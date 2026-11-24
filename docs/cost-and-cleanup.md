# CloudForge Cost Management and Cleanup Guide

## 1. Purpose

This guide explains how CloudForge controls cloud spending, avoids unnecessary AWS resource creation, and safely cleans up resources after approved practice sessions.

The project prioritizes local development and testing before moving to cloud infrastructure.

## 2. AWS Practice Budget

The total AWS practice budget for Day 29 and the final project is limited to ₹500.

This is a maximum spending limit, not a target.

Before creating any AWS resource:

1. Explain the purpose of the resource.
2. Estimate its possible cost.
3. Identify safer or free alternatives.
4. Obtain explicit approval before proceeding.
5. Plan how and when the resource will be removed.

AWS credits must not be treated as a guarantee that no money will be charged.

## 3. Prefer Local Development

Use local tools whenever possible:

- Python virtual environments for application development.
- pytest for automated testing.
- Docker Desktop for container builds and deployment simulations.
- Local Terraform formatting and validation.
- GitHub Actions for CI and approval-gate practice.

These activities allow most project development to happen without creating AWS infrastructure.

## 4. AWS Billing Monitoring

Before and after any approved AWS practice session, review:

- **AWS Billing:** Check current charges and estimated costs.
- **AWS Cost Explorer:** Review service-level spending and usage trends.
- **AWS Credits:** Check remaining credit balance and expiration information.

Review these regularly rather than waiting until the end of the project.

## 5. Resource Creation Approval

No billable AWS resource should be created without explicit approval.

Before an approved deployment, identify:

- AWS service and resource type.
- AWS region.
- Expected running duration.
- Estimated hourly or monthly cost.
- Possible additional charges.
- Cleanup procedure.

Do not assume that Free Tier eligibility or available credits make a resource completely free.

## 6. AWS Cleanup Checklist

After an approved AWS lab:

1. Stop or terminate temporary compute resources when no longer needed.
2. Delete temporary load balancers and related resources.
3. Remove unused storage volumes and snapshots when they are no longer required.
4. Delete temporary networking resources where appropriate.
5. Remove temporary container images and repositories if they are no longer needed.
6. Review IAM users, roles, policies, and temporary credentials.
7. Check AWS Billing and Cost Explorer for unexpected charges.

Follow resource dependencies and service-specific deletion requirements. Do not delete resources that contain required data or are still in use.

## 7. Terraform Safety

Terraform commands have different effects:

- `terraform fmt`: Formats Terraform files.
- `terraform validate`: Checks configuration validity.
- `terraform plan`: Previews proposed infrastructure changes.
- `terraform apply`: Creates or changes infrastructure.
- `terraform destroy`: Requests destruction of managed infrastructure.

Always review a plan before applying changes.

Never run `terraform apply` or `terraform destroy` without understanding the proposed changes and obtaining the required approval.

Terraform state files should not be committed to GitHub because they may contain sensitive infrastructure information.

## 8. CloudForge Current Status

The current CloudForge project uses local development and deployment simulations.

Completed without creating CloudForge AWS infrastructure:

- Flask application and automated tests.
- Docker image builds and local container deployments.
- Container security checks.
- Terraform formatting and validation.
- GitHub Actions CI pipeline.
- Manual production approval simulation.
- Local deployment and rollback-protection testing.

AWS infrastructure deployment has not started.

## 9. Final Cost-Safety Principles

- Prefer local simulations over paid cloud resources.
- Never create billable resources without explicit approval.
- Check Billing, Cost Explorer, and remaining credits regularly.
- Keep the total AWS practice budget within ₹500.
- Clean up approved temporary resources promptly.
- Verify that cleanup succeeded.
- Never assume AWS credits guarantee zero out-of-pocket costs.
