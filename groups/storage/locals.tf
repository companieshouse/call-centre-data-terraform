locals {
  common_tags = {
    Environment = var.environment
    Provisioner = "Terraform"
    Repository  = var.repository
    Service     = var.service
  }

  aws_account_id = data.aws_caller_identity.current.account_id
}
