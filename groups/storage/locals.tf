locals {
  common_tags = {
    Environment = var.environment
    Provisioner = "Terraform"
    Repository  = var.repository
    Service     = var.service
  }

  aws_account_id = data.aws_caller_identity.current.account_id

  trusted_sso_role_ids = formatlist("%s:*", [for o in data.aws_iam_role.call_centre_data : o.unique_id])
}
