// File: test/iam_policy_basic_test.go
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

// TestIAMPolicyBasic tests creating IAM policies
func TestIAMPolicyBasic(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	policyName := fmt.Sprintf("tt-iam-policy-%s", unique)

	tfDir := "../examples/policy/basic"

	// Create tfvars file to avoid complex variable escaping issues
	tfvarsContent := fmt.Sprintf(`
region = "us-east-1"

iam_policies = [
  {
    name        = "%s"
    description = "Test IAM policy created by Terratest"
    policy      = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = ["s3:GetObject"]
          Resource = ["*"]
        }
      ]
    })
  }
]
`, policyName)

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

	outputPolicyArns := terraform.OutputMap(t, tfOptions, "policy_arns")
	policyArn, exists := outputPolicyArns[policyName]
	require.True(t, exists, "Expected policy %q in output", policyName)

	policyExists := policyExists(t, client, policyArn)
	require.True(t, policyExists, "Expected policy %q to exist", policyName)
}
