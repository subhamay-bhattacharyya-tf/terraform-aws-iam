// File: test/iam_role_basic_test.go
package test

import (
	"fmt"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestIAMRoleBasic tests creating IAM roles with inline policies
func TestIAMRoleBasic(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	roleName := fmt.Sprintf("tt-iam-role-%s", unique)

	tfDir := "../examples/role/basic"

	// Pre-encoded JSON strings (tfvars doesn't support functions)
	assumeRolePolicyJSON := `{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"lambda.amazonaws.com"},"Action":"sts:AssumeRole"}]}`
	inlinePolicyJSON := `{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":["s3:GetObject"],"Resource":["*"]}]}`

	// Create tfvars file with pre-encoded JSON
	tfvarsContent := fmt.Sprintf(`
region = "us-east-1"

iam_roles = [
  {
    name               = "%s"
    description        = "Test IAM role created by Terratest"
    assume_role_policy = %q
    inline_policies = [
      {
        name   = "test-inline-policy"
        policy = %q
      }
    ]
  }
]
`, roleName, assumeRolePolicyJSON, inlinePolicyJSON)

	tfvarsFile := fmt.Sprintf("%s/test_%s.auto.tfvars", tfDir, unique)
	err := os.WriteFile(tfvarsFile, []byte(tfvarsContent), 0644)
	require.NoError(t, err, "Failed to write tfvars file")
	defer os.Remove(tfvarsFile)

	tfOptions := &terraform.Options{
		TerraformDir: tfDir,
		NoColor:      true,
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	client := getIAMClient(t)

	outputRoleArns := terraform.OutputMap(t, tfOptions, "role_arns")
	roleArn, exists := outputRoleArns[roleName]
	require.True(t, exists, "Expected role %q in output", roleName)

	roleExists := roleExists(t, client, roleName)
	require.True(t, roleExists, "Expected role %q to exist", roleName)
	require.Contains(t, roleArn, roleName)
}
