# Basic IAM Policy Example

This example demonstrates how to create a basic IAM policy using the `policy` module.

## Usage

```hcl
module "iam_policy" {
  source = "../../../modules/policy"

  iam_policy_config = {
    name        = "my-policy"
    description = "My custom IAM policy"
    policy      = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = ["s3:GetObject"]
          Resource = ["arn:aws:s3:::my-bucket/*"]
        }
      ]
    })
  }
}
```

## Running the Example

```bash
terraform init
terraform plan -var='iam_policy={"name":"test-policy","policy":"{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"s3:GetObject\"],\"Resource\":[\"*\"]}]}"}'
terraform apply -var='iam_policy={"name":"test-policy","policy":"{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"s3:GetObject\"],\"Resource\":[\"*\"]}]}"}'
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| region | AWS region | string | no |
| iam_policy | IAM policy configuration | object | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy_id | The policy's ID |
| policy_arn | The ARN assigned by AWS to this policy |
| policy_name | The name of the policy |
| policy_path | The path of the policy in IAM |
