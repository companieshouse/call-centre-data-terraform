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
