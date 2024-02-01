resource "aws_iam_user" "data" {
  name = "${var.environment}-${var.service}-accessor"
  tags = local.common_tags
}

resource "aws_iam_access_key" "data" {
  user = aws_iam_user.data.name
}

resource "aws_iam_policy" "data" {
  name        = "${var.environment}-${var.service}-accessor"
  description = "IAM policy for accessor user to manage objects in call centre data S3 bucket"
  policy      = data.aws_iam_policy_document.data.json
  tags        = local.common_tags
}

resource "aws_iam_user_policy_attachment" "data" {
  user       = aws_iam_user.data.name
  policy_arn = aws_iam_policy.data.arn
}

resource "aws_iam_user" "data_migration" {
  count = var.data_migration_enabled ? 1 : 0
  name  = "${var.environment}-${var.service}-migrator"
  tags  = local.common_tags
}

resource "aws_iam_access_key" "data_migration" {
  count = var.data_migration_enabled ? 1 : 0
  user  = aws_iam_user.data_migration[0].name
}

resource "aws_iam_role" "data_migration" {
  count              = var.data_migration_enabled ? 1 : 0
  name               = "${var.environment}-${var.service}-data-migrator-role"
  assume_role_policy = data.aws_iam_policy_document.data_migration_trust[0].json
  tags               = local.common_tags
}

resource "aws_iam_policy" "data_migration" {
  count       = var.data_migration_enabled ? 1 : 0
  name        = "${var.environment}-${var.service}-migrator"
  description = "IAM policy for migrator role to retrieve objects from external S3 bucket and write objects to call centre data S3 bucket"
  policy      = data.aws_iam_policy_document.data_migration_execution[0].json
  tags        = local.common_tags
}

resource "aws_iam_role_policy_attachment" "data_migration" {
  count      = var.data_migration_enabled ? 1 : 0
  role       = aws_iam_role.data_migration[0].name
  policy_arn = aws_iam_policy.data_migration[0].arn
}
