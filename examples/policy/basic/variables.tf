# -- examples/policy/basic/variables.tf (Example)
# ============================================================================
# Example: Basic IAM Policy - Variables
# ============================================================================

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "iam_policies" {
  description = "List of IAM policy configurations"
  type = list(object({
    name        = string
    description = optional(string, "Managed by Terraform")
    path        = optional(string, "/")
    policy      = string
    tags        = optional(map(string), {})
  }))
}
