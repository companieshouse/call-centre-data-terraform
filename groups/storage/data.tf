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

data "aws_iam_policy_document" "data_migration_execution" {
  count = var.data_migration_enabled ? 1 : 0

  statement {
    sid = "AllowDataMigrationUserToListSourceBucket"

    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "${var.data_migration_source_bucket_arn}"
    ]
  }

  statement {
    sid = "AllowDataMigrationUserToGetObjectsInSourceBucket"

    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionTagging"
    ]

    resources = [
      "${var.data_migration_source_bucket_arn}/*"
    ]
  }

  statement {
    sid = "AllowDataMigrationUserToListDestinationBucket"

    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.data.arn
    ]
  }

  statement {
    sid = "AllowDataMigrationUserToPutObjectsInDestinationBucket"

    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionTagging"
    ]

    resources = [
      "${aws_s3_bucket.data.arn}/*"
    ]
  }

  dynamic "statement" {
    for_each = var.data_migration_source_kms_key_arn != "" ? [1] : []

    content {
      sid = "AllowUseOfExternalKMSKey"

      effect = "Allow"

      actions = [
        "kms:*"
      ]

      resources =  [
        var.data_migration_source_kms_key_arn
      ]
    }
  }
}

data "aws_iam_policy_document" "data_migration_trust" {
  count = var.data_migration_enabled ? 1 : 0

  statement {
    sid = "AllowDataMigrationUserToAssumeThisRole"

    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "AWS"

      identifiers = [
        aws_iam_user.data_migration[0].arn
      ]
    }
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
