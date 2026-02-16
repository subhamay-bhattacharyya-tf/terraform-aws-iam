# -- modules/role/outputs.tf (Child Module)
# ============================================================================
# IAM Role Module - Outputs
# ============================================================================

output "roles" {
  description = "Map of created IAM roles with their attributes"
  value = {
    for name, role in aws_iam_role.this : name => {
      id                   = role.id
      arn                  = role.arn
      name                 = role.name
      path                 = role.path
      unique_id            = role.unique_id
      assume_role_policy   = role.assume_role_policy
      max_session_duration = role.max_session_duration
    }
  }
}

output "role_arns" {
  description = "Map of role names to their ARNs"
  value       = { for name, role in aws_iam_role.this : name => role.arn }
}

output "role_names" {
  description = "List of created role names"
  value       = [for name, role in aws_iam_role.this : role.name]
}
