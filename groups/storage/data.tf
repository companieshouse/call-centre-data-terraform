data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "accessor" {
  statement {
    sid = "AllowDataUserToListBucket"

    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      aws_s3_bucket.data.arn
    ]
  }

  statement {
    sid = "AllowDataUserToGetObjectsInBucket"

    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.data.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "data" {

  statement {
    sid = "DenyAllActionsForUntrustedPrincipals"

    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.data.arn,
      "${aws_s3_bucket.data.arn}/*"
    ]

    condition {
      test     = "StringNotLike"
      variable = "aws:userId"
      values = concat(local.trusted_sso_role_ids, [
        aws_iam_user.data.unique_id,
        aws_iam_user.data_2.unique_id,
        data.aws_caller_identity.current.account_id,
        data.vault_generic_secret.secrets.data["concourse-user-id"]
      ])
    }
  }

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

  statement {
    sid = "DenyNonSSLRequests"

    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.data.arn,
      "${aws_s3_bucket.data.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

data "aws_iam_roles" "call_centre_data" {
  name_regex  = "AWSReservedSSO_CallCentreData_.*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/${var.region}"
}

data "aws_iam_role" "call_centre_data" {
  for_each = data.aws_iam_roles.call_centre_data.names
  name     = each.key
}

data "vault_generic_secret" "secrets" {
  path = "aws-accounts/${var.aws_account}/configuration"
}
