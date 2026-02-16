// File: test/iam_role_basic_test.go
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

// TestIAMRoleBasic tests creating IAM roles with inline policies
func TestIAMRoleBasic(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	roleName := fmt.Sprintf("tt-iam-role-%s", unique)

	tfDir := "../examples/role/basic"

	assumeRolePolicy := map[string]interface{}{
		"Version": "2012-10-17",
		"Statement": []map[string]interface{}{
			{
				"Effect":    "Allow",
				"Principal": map[string]interface{}{"Service": "lambda.amazonaws.com"},
				"Action":    "sts:AssumeRole",
			},
		},
	}

	inlinePolicy := map[string]interface{}{
		"Version": "2012-10-17",
		"Statement": []map[string]interface{}{
			{
				"Effect":   "Allow",
				"Action":   []string{"s3:GetObject"},
				"Resource": []string{"*"},
			},
		},
	}

	assumeRolePolicyJSON, err := json.Marshal(assumeRolePolicy)
	require.NoError(t, err, "Failed to marshal assume role policy")

	inlinePolicyJSON, err := json.Marshal(inlinePolicy)
	require.NoError(t, err, "Failed to marshal inline policy")

	iamRoles := []map[string]interface{}{
		{
			"name":               roleName,
			"description":        "Test IAM role created by Terratest",
			"assume_role_policy": string(assumeRolePolicyJSON),
			"inline_policies": []map[string]interface{}{
				{
					"name":   "test-inline-policy",
					"policy": string(inlinePolicyJSON),
				},
			},
		},
	}

	tfOptions := &terraform.Options{
		TerraformDir: tfDir,
		NoColor:      true,
		Vars: map[string]interface{}{
			"region":    "us-east-1",
			"iam_roles": iamRoles,
		},
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
