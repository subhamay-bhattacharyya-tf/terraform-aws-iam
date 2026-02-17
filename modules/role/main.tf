# -- modules/role/main.tf (Child Module)
# ============================================================================
# AWS IAM Role Resource
# Creates and manages IAM role with inline and managed policies
# ============================================================================

resource "aws_iam_role" "this" {
  name                  = var.iam_role.name
  description           = var.iam_role.description
  path                  = var.iam_role.path
  assume_role_policy    = var.iam_role.assume_role_policy
  max_session_duration  = var.iam_role.max_session_duration
  permissions_boundary  = var.iam_role.permissions_boundary
  force_detach_policies = var.iam_role.force_detach_policies

  tags = merge(
    {
      Name = var.iam_role.name
    },
    var.iam_role.tags
  )
}

# Inline policies
resource "aws_iam_role_policy" "inline" {
  for_each = { for p in var.iam_role.inline_policies : p.name => p }

  name   = each.value.name
  role   = aws_iam_role.this.id
  policy = each.value.policy
}

# Managed policy attachments
resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.iam_role.managed_policy_arns)

  role       = aws_iam_role.this.id
  policy_arn = each.value
}
