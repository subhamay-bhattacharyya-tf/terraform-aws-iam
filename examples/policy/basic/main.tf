# -- examples/policy/basic/main.tf (Example)
# ============================================================================
# Example: Basic IAM Policy
#
# This example demonstrates how to use the iam-policy module
# to create one or more IAM policies with custom permissions.
# ============================================================================

module "iam_policy" {
  source = "../../../modules/policy"

  iam_policies = var.iam_policies
}
