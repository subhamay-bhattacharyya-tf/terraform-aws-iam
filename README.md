# Terraform AWS IAM Module

![Release](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-iam/actions/workflows/ci.yaml/badge.svg)&nbsp;![AWS](https://img.shields.io/badge/AWS-232F3E?logo=amazonaws&logoColor=white)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-tf/terraform-aws-iam)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-tf/terraform-aws-iam)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-tf/terraform-aws-iam)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-tf/terraform-aws-iam)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-tf/terraform-aws-iam)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-tf/terraform-aws-iam)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-tf/terraform-aws-iam)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/cd418dcd5a97ce43695e9fbbae1c367d/raw/terraform-aws-iam.json?)

A Terraform module for creating and managing AWS IAM resources including policies, roles, and users.

## Features

- JSON-style configuration input
- IAM policy creation with custom permissions
- Built-in input validation
- Configurable paths and tags

## Modules

| Module | Description |
|--------|-------------|
| [policy](modules/policy) | IAM policy with custom permissions |

## Usage

### Basic IAM Policy

```hcl
module "iam_policy" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-iam//modules/policy?ref=main"

  iam_policy_config = {
    name   = "my-policy"
    policy = jsonencode({
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

### IAM Policy with Description and Path

```hcl
module "iam_policy" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-iam//modules/policy?ref=main"

  iam_policy_config = {
    name        = "my-custom-policy"
    description = "Custom policy for S3 read access"
    path        = "/custom/"
    policy      = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = [
            "s3:GetObject",
            "s3:ListBucket"
          ]
          Resource = [
            "arn:aws:s3:::my-bucket",
            "arn:aws:s3:::my-bucket/*"
          ]
        }
      ]
    })
    tags = {
      Environment = "production"
      Team        = "platform"
    }
  }
}
```

### IAM Policy for EC2 Access

```hcl
module "ec2_policy" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-iam//modules/policy?ref=main"

  iam_policy_config = {
    name        = "ec2-read-only"
    description = "Read-only access to EC2 resources"
    policy      = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "ec2:Describe*",
            "ec2:Get*"
          ]
          Resource = "*"
        }
      ]
    })
  }
}
```

### Basic IAM Role

```hcl
module "iam_role" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-iam//modules/role?ref=main"

  iam_role = {
    name = "my-lambda-role"
    assume_role_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Service = "lambda.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ]
    })
  }
}
```

### IAM Role with Inline and Managed Policies

```hcl
module "iam_role" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-iam//modules/role?ref=main"

  iam_role = {
    name        = "my-ec2-role"
    description = "Role for EC2 instances"
    path        = "/service-roles/"
    assume_role_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ]
    })
    max_session_duration = 7200
    inline_policies = [
      {
        name = "s3-access"
        policy = jsonencode({
          Version = "2012-10-17"
          Statement = [
            {
              Effect   = "Allow"
              Action   = ["s3:GetObject", "s3:ListBucket"]
              Resource = ["arn:aws:s3:::my-bucket", "arn:aws:s3:::my-bucket/*"]
            }
          ]
        })
      }
    ]
    managed_policy_arns = [
      "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
    ]
    tags = {
      Environment = "production"
      Team        = "platform"
    }
  }
}
```

## Examples

### Policy Examples

| Example | Description |
|---------|-------------|
| [basic](examples/policy/basic) | Simple IAM policy |

### Role Examples

| Example | Description |
|---------|-------------|
| [basic](examples/role/basic) | IAM role with inline and managed policies |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| aws | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0.0 |

## Modules

| Module | Description |
|--------|-------------|
| [policy](modules/policy) | IAM policy with custom permissions |
| [role](modules/role) | IAM role with inline and managed policies |

## Policy Module

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| iam_policy_config | Configuration object for IAM policy | `object` | - | yes |

### iam_policy_config Object Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| name | string | - | Name of the IAM policy (required) |
| description | string | "Managed by Terraform" | Description of the policy |
| path | string | "/" | Path in which to create the policy |
| policy | string | - | JSON policy document (required) |
| tags | map(string) | {} | Tags to apply to the policy |

### Outputs

| Name | Description |
|------|-------------|
| policy_id | The policy's ID |
| policy_arn | The ARN assigned by AWS to this policy |
| policy_name | The name of the policy |
| policy_path | The path of the policy in IAM |
| policy_document | The policy document |

## Resources Created

### Policy Module

| Resource | Description |
|----------|-------------|
| aws_iam_policy | The IAM policy |

### Role Module

| Resource | Description |
|----------|-------------|
| aws_iam_role | The IAM role |
| aws_iam_role_policy | Inline policies attached to the role |
| aws_iam_role_policy_attachment | Managed policy attachments |

## Role Module

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| iam_role | IAM role configuration | `object` | - | yes |

### iam_role Object Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| name | string | - | Name of the IAM role (required) |
| description | string | "Managed by Terraform" | Description of the role |
| path | string | "/" | Path in which to create the role |
| assume_role_policy | string | - | JSON trust policy document (required) |
| max_session_duration | number | 3600 | Maximum session duration in seconds (3600-43200) |
| permissions_boundary | string | null | ARN of the permissions boundary policy |
| force_detach_policies | bool | false | Force detach policies before destroying |
| inline_policies | list(object) | [] | List of inline policies to attach |
| managed_policy_arns | list(string) | [] | List of managed policy ARNs to attach |
| tags | map(string) | {} | Tags to apply to the role |

### inline_policies Object Properties

| Property | Type | Description |
|----------|------|-------------|
| name | string | Name of the inline policy |
| policy | string | JSON policy document |

### Outputs

| Name | Description |
|------|-------------|
| role | The created IAM role with its attributes |
| role_arn | The ARN of the IAM role |
| role_name | The name of the IAM role |

## Validation

The module validates inputs and provides descriptive error messages for:

- Empty policy name
- Policy name exceeding 128 characters
- Invalid path format
- Invalid JSON policy document

## Testing

The module includes Terratest-based integration tests:

```bash
cd test
go mod tidy
go test -v -timeout 30m
```

### Test Cases

| Test | Description |
|------|-------------|
| TestIAMPolicyBasic | Basic policy creation |
| TestIAMRoleBasic | Basic role creation with policies |

AWS credentials must be configured via environment variables or AWS CLI profile.

## CI/CD Configuration

The CI workflow runs on:
- Push to `main`, `feature/**`, and `bug/**` branches (when `modules/**` changes)
- Pull requests to `main` (when `modules/**` changes)
- Manual workflow dispatch

The workflow includes:
- Terraform validation and format checking
- Examples validation
- Terratest integration tests
- Changelog generation (non-main branches)
- Semantic release (main branch only)

### GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AWS_ROLE_ARN` | IAM role ARN for OIDC authentication |

### GitHub Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TERRAFORM_VERSION` | Terraform version for CI jobs | `1.3.0` |
| `GO_VERSION` | Go version for Terratest | `1.21` |

## License

MIT License - See [LICENSE](LICENSE) for details.
