# -- examples/role/basic/variables.tf (Example)
# ============================================================================
# Example: Basic IAM Role - Variables
# ============================================================================

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "iam_roles" {
  description = "List of IAM role configurations"
  type = list(object({
    name                  = string
    description           = optional(string, "Managed by Terraform")
    path                  = optional(string, "/")
    assume_role_policy    = string
    max_session_duration  = optional(number, 3600)
    permissions_boundary  = optional(string, null)
    force_detach_policies = optional(bool, false)
    tags                  = optional(map(string), {})
    inline_policies = optional(list(object({
      name   = string
      policy = string
    })), [])
    managed_policy_arns = optional(list(string), [])
  }))
}
