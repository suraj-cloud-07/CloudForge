output "project_name" {
  description = "CloudForge project name"
  value       = terraform_data.cloudforge.output.project
}

output "environment" {
  description = "CloudForge environment"
  value       = terraform_data.cloudforge.output.environment
}
