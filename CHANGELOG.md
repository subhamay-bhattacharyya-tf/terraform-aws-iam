# Changelog

All notable changes to this project will be documented in this file.

## 1.0.0 (2026-02-18)

### ⚠ BREAKING CHANGES

* Initial release of Terraform AWS IAM module

- Add modules/policy for IAM policy management with list-based input
- Add modules/role for IAM role management with inline and managed policies
- Support multiple policies/roles per module call via list configuration
- Include examples and Terratest integration tests

### Features

* initial release of AWS IAM module ([ab80ae9](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-iam/commit/ab80ae9853a8d5f6b48c00070d871d5e46d2fe52))
* **role:** add IAM role module with inline and managed policies ([82b49b0](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-iam/commit/82b49b0656cc5a32c1b5eac360676ec765ce99b7))

## [unreleased]

### 🚀 Features

- [**breaking**] Initial release of AWS IAM module
- *(role)* Add IAM role module with inline and managed policies

### 📚 Documentation

- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]

### 🧪 Testing

- *(iam)* Refactor tests to use tfvars files instead of inline vars
- *(iam)* Simplify policy JSON encoding in tfvars generation
