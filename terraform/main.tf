terraform {
  required_version = ">= 1.5.0"
}

resource "terraform_data" "cloudforge" {
  input = {
    project     = var.project_name
    environment = var.environment
  }
}
