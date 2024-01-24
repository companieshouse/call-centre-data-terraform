data "aws_iam_policy_document" "data" {
  statement {
    sid = "AllowDataUserToListBucket"

    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.data.arn
    ]
  }

  statement {
    sid = "AllowDataUserToPutAndGetObjectsInBucket"

    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:GetObjectAcl"
    ]

    resources = [
      "${aws_s3_bucket.data.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "bucket" {
  statement {
    sid = "DenyPutObjectWithKmsEncryptionHeader"

    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.data.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }
  }
}
