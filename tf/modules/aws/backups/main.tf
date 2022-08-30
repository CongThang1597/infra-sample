resource "aws_backup_vault" "root" {
  name = "${var.project}-${var.environment}-${var.action_name}-backup-vault"
}

resource "aws_backup_plan" "root" {
  name = "${var.project}-${var.environment}-${var.action_name}-backup-plan"

  rule {
    rule_name         = "${var.project}-${var.environment}-${var.action_name}-backup-rule"
    target_vault_name = aws_backup_vault.root.name
    schedule          = var.schedule

    lifecycle {
      delete_after = 14
    }
  }
}

resource "aws_backup_selection" "root" {
  iam_role_arn = var.backup_service_role_arn
  name         = "${var.project}-${var.environment}-${var.action_name}-backup-selection"
  plan_id      = aws_backup_plan.root.id

  resources = var.selection_resources
}
