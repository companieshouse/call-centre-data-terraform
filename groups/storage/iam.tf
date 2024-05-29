resource "aws_iam_user" "data" {
  name = "${var.environment}-${var.service}-accessor"
  tags = local.common_tags
}

resource "aws_iam_user" "data_2" {
  name = "${var.environment}-${var.service}-accessor-2"
  tags = local.common_tags
}

resource "aws_iam_user" "data_3" {
  name = "${var.environment}-${var.service}-accessor-3"
  tags = local.common_tags
}

resource "aws_iam_access_key" "data" {
  user = aws_iam_user.data.name
}

resource "aws_iam_access_key" "data_2" {
  user = aws_iam_user.data_2.name
}

resource "aws_iam_access_key" "data_3" {
  user = aws_iam_user.data_3.name
}

resource "aws_iam_policy" "accessor" {
  name        = "${var.environment}-${var.service}-accessor"
  description = "IAM policy for read-only access to objects in the call centre data S3 bucket"
  policy      = data.aws_iam_policy_document.accessor.json
  tags        = local.common_tags
}

resource "aws_iam_user_policy_attachment" "data" {
  user       = aws_iam_user.data.name
  policy_arn = aws_iam_policy.accessor.arn
}

resource "aws_iam_user_policy_attachment" "data_2" {
  user       = aws_iam_user.data_2.name
  policy_arn = aws_iam_policy.accessor.arn
}

resource "aws_iam_user_policy_attachment" "data_3" {
  user       = aws_iam_user.data_3.name
  policy_arn = aws_iam_policy.accessor.arn
}
