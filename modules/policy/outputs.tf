# -- modules/policy/outputs.tf (Child Module)
# ============================================================================
# IAM Policy Module - Outputs
# ============================================================================

output "policies" {
  description = "Map of created IAM policies with their attributes"
  value = {
    for name, policy in aws_iam_policy.this : name => {
      id       = policy.id
      arn      = policy.arn
      name     = policy.name
      path     = policy.path
      document = policy.policy
    }
  }
}

output "policy_arns" {
  description = "Map of policy names to their ARNs"
  value       = { for name, policy in aws_iam_policy.this : name => policy.arn }
}
