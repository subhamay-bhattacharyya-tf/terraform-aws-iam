# -- examples/role/basic/main.tf (Example)
# ============================================================================
# Example: Basic IAM Role
#
# This example demonstrates how to use the iam-role module
# to create IAM roles with inline and managed policies.
# ============================================================================

module "iam_role" {
  source = "../../../modules/role"

  iam_role = var.iam_role
}
