# -- modules/role/outputs.tf (Child Module)
# ============================================================================
# IAM Role Module - Outputs
# ============================================================================

output "role" {
  description = "The created IAM role with its attributes"
  value = {
    id                   = aws_iam_role.this.id
    arn                  = aws_iam_role.this.arn
    name                 = aws_iam_role.this.name
    path                 = aws_iam_role.this.path
    unique_id            = aws_iam_role.this.unique_id
    assume_role_policy   = aws_iam_role.this.assume_role_policy
    max_session_duration = aws_iam_role.this.max_session_duration
  }
}

output "role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.this.name
}
