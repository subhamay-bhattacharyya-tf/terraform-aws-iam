# -- modules/policy/main.tf (Child Module)
# ============================================================================
# AWS IAM Policy Resource
# Creates and manages IAM policies with configurable permissions
# ============================================================================

resource "aws_iam_policy" "this" {
  for_each = { for p in var.iam_policies : p.name => p }

  name        = each.value.name
  description = each.value.description
  path        = each.value.path
  policy      = each.value.policy

  tags = merge(
    {
      Name = each.value.name
    },
    each.value.tags
  )
}
