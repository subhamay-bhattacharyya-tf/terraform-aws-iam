# -- modules/role/variables.tf (Child Module)
# ============================================================================
# IAM Role Module - Variables
# ============================================================================

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

    # Inline policies
    inline_policies = optional(list(object({
      name   = string
      policy = string
    })), [])

    # Managed policy ARNs to attach
    managed_policy_arns = optional(list(string), [])
  }))

  validation {
    condition     = alltrue([for r in var.iam_roles : length(r.name) > 0])
    error_message = "Role name must not be empty."
  }

  validation {
    condition     = alltrue([for r in var.iam_roles : length(r.name) <= 64])
    error_message = "Role name must be 64 characters or less."
  }

  validation {
    condition     = alltrue([for r in var.iam_roles : can(regex("^(/[a-zA-Z0-9._-]+)*/$", r.path)) || r.path == "/"])
    error_message = "Path must start and end with '/' and contain only alphanumeric characters, '.', '_', or '-'."
  }

  validation {
    condition     = alltrue([for r in var.iam_roles : can(jsondecode(r.assume_role_policy))])
    error_message = "assume_role_policy must be a valid JSON string."
  }

  validation {
    condition     = alltrue([for r in var.iam_roles : r.max_session_duration >= 3600 && r.max_session_duration <= 43200])
    error_message = "max_session_duration must be between 3600 and 43200 seconds."
  }

  validation {
    condition = alltrue(flatten([
      for r in var.iam_roles : [
        for p in r.inline_policies : can(jsondecode(p.policy))
      ]
    ]))
    error_message = "All inline policies must be valid JSON strings."
  }
}
