# -- modules/role/main.tf (Child Module)
# ============================================================================
# AWS IAM Role Resource
# Creates and manages IAM roles with inline and managed policies
# ============================================================================

resource "aws_iam_role" "this" {
  for_each = { for r in var.iam_roles : r.name => r }

  name                  = each.value.name
  description           = each.value.description
  path                  = each.value.path
  assume_role_policy    = each.value.assume_role_policy
  max_session_duration  = each.value.max_session_duration
  permissions_boundary  = each.value.permissions_boundary
  force_detach_policies = each.value.force_detach_policies

  tags = merge(
    {
      Name = each.value.name
    },
    each.value.tags
  )
}

# Inline policies
resource "aws_iam_role_policy" "inline" {
  for_each = {
    for item in flatten([
      for r in var.iam_roles : [
        for p in r.inline_policies : {
          role_name   = r.name
          policy_name = p.name
          policy      = p.policy
          key         = "${r.name}:${p.name}"
        }
      ]
    ]) : item.key => item
  }

  name   = each.value.policy_name
  role   = aws_iam_role.this[each.value.role_name].id
  policy = each.value.policy
}

# Managed policy attachments
resource "aws_iam_role_policy_attachment" "managed" {
  for_each = {
    for item in flatten([
      for r in var.iam_roles : [
        for arn in r.managed_policy_arns : {
          role_name  = r.name
          policy_arn = arn
          key        = "${r.name}:${arn}"
        }
      ]
    ]) : item.key => item
  }

  role       = aws_iam_role.this[each.value.role_name].id
  policy_arn = each.value.policy_arn
}
