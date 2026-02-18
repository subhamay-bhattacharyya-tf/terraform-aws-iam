# Basic IAM Role Example

This example demonstrates how to create IAM roles with inline and managed policies.

## Usage

```hcl
module "iam_role" {
  source = "../../../modules/role"

  iam_roles = [
    {
      name        = "my-lambda-role"
      description = "Role for Lambda function"
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect    = "Allow"
          Principal = { Service = "lambda.amazonaws.com" }
          Action    = "sts:AssumeRole"
        }]
      })
      inline_policies = [
        {
          name = "s3-access"
          policy = jsonencode({
            Version = "2012-10-17"
            Statement = [{
              Effect   = "Allow"
              Action   = ["s3:GetObject"]
              Resource = ["arn:aws:s3:::my-bucket/*"]
            }]
          })
        }
      ]
      managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
      ]
    }
  ]
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| region | AWS region | string | no |
| iam_roles | List of IAM role configurations | list(object) | yes |

## Outputs

| Name | Description |
|------|-------------|
| roles | Map of created IAM roles with their attributes |
| role_arns | Map of role names to their ARNs |
| role_names | List of created role names |
