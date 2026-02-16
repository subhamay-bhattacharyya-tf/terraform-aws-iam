// File: test/iam_policy_basic_test.go
package test

import (
	"encoding/json"
	"fmt"
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

	policyDocument := map[string]interface{}{
		"Version": "2012-10-17",
		"Statement": []map[string]interface{}{
			{
				"Effect":   "Allow",
				"Action":   []string{"s3:GetObject"},
				"Resource": []string{"*"},
			},
		},
	}

	policyJSON, err := json.Marshal(policyDocument)
	require.NoError(t, err, "Failed to marshal policy document")

	iamPolicies := []map[string]interface{}{
		{
			"name":        policyName,
			"description": "Test IAM policy created by Terratest",
			"policy":      string(policyJSON),
		},
	}

	tfOptions := &terraform.Options{
		TerraformDir: tfDir,
		NoColor:      true,
		Vars: map[string]interface{}{
			"region":       "us-east-1",
			"iam_policies": iamPolicies,
		},
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
