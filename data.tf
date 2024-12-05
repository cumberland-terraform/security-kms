data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "merged" {
    count                   = local.conditions.merge ? 1 : 0

    source_policy_documents = concat(
                              [ data.aws_iam_policy_document.unmerged.json ],
                                var.kms.additional_policies
                            )
    
}

data "aws_iam_policy_document" "unmerged" {
  statement {
    sid                     = "EnableAdminPerms"
    effect                  = "Allow"
    actions                 = [ 
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources               = [ "*" ]

    principals {
      type                  =  "AWS"
      identifiers           = local.unmerged_policy_principals
    }
  }

  statement {
    sid                     = "EnableIAMPerms"
    effect                  = "Allow"
    actions                 = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources               = [ "*" ]

    principals {
      type                  =  "AWS"
      identifiers           = local.unmerged_policy_principals
    }

    principals {
      type                  = "Service"
      identifiers           = [ "logs.${module.platform.aws.region}.amazonaws.com" ]
    }
  }

  statement {
    sid                     = "Allow attachment of persistent resources"
    effect                  = "Allow"
    actions                 = [
      "kms:CreateGrant"
    ]

    principals {
      type                  =  "AWS"
      identifiers           = local.unmerged_policy_principals
    }

    condition {
      test                  = "Bool"
      variable              = "kms:GrantIsForAWSResource"
      values                = [ true ]
    }
  }
}