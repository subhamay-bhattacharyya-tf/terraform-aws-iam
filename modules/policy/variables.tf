# -- modules/policy/variables.tf (Child Module)
# ============================================================================
# IAM Policy Module - Variables
# ============================================================================

variable "iam_policies" {
  description = "List of IAM policy configurations"
  type = list(object({
    name        = string
    description = optional(string, "Managed by Terraform")
    path        = optional(string, "/")
    policy      = string
    tags        = optional(map(string), {})
  }))

  validation {
    condition     = alltrue([for p in var.iam_policies : length(p.name) > 0])
    error_message = "Policy name must not be empty."
  }

  validation {
    condition     = alltrue([for p in var.iam_policies : length(p.name) <= 128])
    error_message = "Policy name must be 128 characters or less."
  }

  validation {
    condition     = alltrue([for p in var.iam_policies : can(regex("^(/[a-zA-Z0-9._-]+)*/$", p.path)) || p.path == "/"])
    error_message = "Path must start and end with '/' and contain only alphanumeric characters, '.', '_', or '-'."
  }

  validation {
    condition     = alltrue([for p in var.iam_policies : can(jsondecode(p.policy))])
    error_message = "Policy must be a valid JSON string."
  }
}
