# -- examples/role/basic/outputs.tf (Example)
# ============================================================================
# Example: Basic IAM Role - Outputs
# ============================================================================

output "roles" {
  description = "Map of created IAM roles with their attributes"
  value       = module.iam_role.roles
}

output "role_arns" {
  description = "Map of role names to their ARNs"
  value       = module.iam_role.role_arns
}

output "role_names" {
  description = "List of created role names"
  value       = module.iam_role.role_names
}
