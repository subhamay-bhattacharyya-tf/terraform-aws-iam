# -- examples/role/basic/outputs.tf (Example)
# ============================================================================
# Example: Basic IAM Role - Outputs
# ============================================================================

output "role" {
  description = "The created IAM role with its attributes"
  value       = module.iam_role.role
}

output "role_arn" {
  description = "The ARN of the IAM role"
  value       = module.iam_role.role_arn
}

output "role_name" {
  description = "The name of the IAM role"
  value       = module.iam_role.role_name
}
