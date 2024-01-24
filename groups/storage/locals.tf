locals {
  common_tags = {
    Environment = var.environment
    Provisioner = "Terraform"
    Repository  = var.repository
    Service     = var.service
  }
}
