terraform {
  required_version = ">= 1.5.0"

}

provider "aws" {
  region = "ap-south-1"
}

resource "terraform_data" "cloudforge" {
  input = {
    project     = var.project_name
    environment = var.environment
  }
}
