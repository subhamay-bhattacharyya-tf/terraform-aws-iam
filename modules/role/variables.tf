# -- modules/role/variables.tf (Child Module)
# ============================================================================
# IAM Role Module - Variables
# ============================================================================

variable "iam_role" {
  description = "IAM role configuration"
  type = object({
    name                  = string
    description           = optional(string, "Managed by Terraform")
    path                  = optional(string, "/")
    assume_role_policy    = string
    max_session_duration  = optional(number, 3600)
    permissions_boundary  = optional(string, null)
    force_detach_policies = optional(bool, false)
    tags                  = optional(map(string), {})

    # Inline policies
    inline_policies = optional(list(object({
      name   = string
      policy = string
    })), [])

    # Managed policy ARNs to attach
    managed_policy_arns = optional(list(string), [])
  })

  validation {
    condition     = length(var.iam_role.name) > 0
    error_message = "Role name must not be empty."
  }

  validation {
    condition     = length(var.iam_role.name) <= 64
    error_message = "Role name must be 64 characters or less."
  }

  validation {
    condition     = can(regex("^(/[a-zA-Z0-9._-]+)*/$", var.iam_role.path)) || var.iam_role.path == "/"
    error_message = "Path must start and end with '/' and contain only alphanumeric characters, '.', '_', or '-'."
  }

  validation {
    condition     = can(jsondecode(var.iam_role.assume_role_policy))
    error_message = "assume_role_policy must be a valid JSON string."
  }

  validation {
    condition     = var.iam_role.max_session_duration >= 3600 && var.iam_role.max_session_duration <= 43200
    error_message = "max_session_duration must be between 3600 and 43200 seconds."
  }

  validation {
    condition     = alltrue([for p in var.iam_role.inline_policies : can(jsondecode(p.policy))])
    error_message = "All inline policies must be valid JSON strings."
  }
}
