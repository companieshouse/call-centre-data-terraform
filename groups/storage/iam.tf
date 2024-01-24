resource "aws_iam_user" "data" {
  name = "${var.environment}-${var.service}"

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.service}-data-user"
  })
}

resource "aws_iam_access_key" "data" {
  user = aws_iam_user.data.name
}

resource "aws_iam_policy" "data" {
  name        = "${var.environment}-${var.service}-data-user-policy"
  description = "IAM policy for data user to access objects in call centre data bucket"
  policy      = data.aws_iam_policy_document.data.json
}

resource "aws_iam_user_policy_attachment" "data" {
  user       = aws_iam_user.data.name
  policy_arn = aws_iam_policy.data.arn
}
