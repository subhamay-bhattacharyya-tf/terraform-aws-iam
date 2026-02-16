# -- examples/policy/basic/outputs.tf (Example)
# ============================================================================
# Example: Basic IAM Policy - Outputs
# ============================================================================

output "policies" {
  description = "Map of created IAM policies with their attributes"
  value       = module.iam_policy.policies
}

output "policy_arns" {
  description = "Map of policy names to their ARNs"
  value       = module.iam_policy.policy_arns
}
