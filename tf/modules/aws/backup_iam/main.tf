data "aws_iam_policy_document" "aws_iam_policy_document" {
  statement {
    sid     = "AssumeServiceRole"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "aws-backup-service-policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

data "aws_iam_policy_document" "pass-role-policy-doc" {
  statement {
    sid       = "ExamplePassRole"
    actions   = ["iam:PassRole"]
    effect    = "Allow"
    resources = ["arn:aws:iam::${var.account_id}:role/*"]
  }
}

resource "aws_iam_role" "aws-backup-service-role" {
  name               = "${var.project}-${var.environment}-aws-backup-service-role"
  description        = "Allows the AWS Backup Service to take scheduled backups"
  assume_role_policy = data.aws_iam_policy_document.aws_iam_policy_document.json
}

resource "aws_iam_role_policy" "backup-service-aws-backup-role-policy" {
  policy = data.aws_iam_policy.aws-backup-service-policy.policy
  role   = aws_iam_role.aws-backup-service-role.name
}

resource "aws_iam_role_policy" "backup-service-pass-role-policy" {
  policy = data.aws_iam_policy_document.pass-role-policy-doc.json
  role   = aws_iam_role.aws-backup-service-role.name
}
