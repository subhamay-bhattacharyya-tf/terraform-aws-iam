// File: test/helpers_test.go
package test

import (
	"context"
	"os"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/iam"
	"github.com/stretchr/testify/require"
)

type IAMPolicyProps struct {
	Name        string
	Arn         string
	Path        string
	Description string
}

func getIAMClient(t *testing.T) *iam.Client {
	t.Helper()

	region := os.Getenv("AWS_REGION")
	if region == "" {
		region = "us-east-1"
	}

	cfg, err := config.LoadDefaultConfig(context.TODO(), config.WithRegion(region))
	require.NoError(t, err, "Failed to load AWS config")

	return iam.NewFromConfig(cfg)
}

func policyExists(t *testing.T, client *iam.Client, policyArn string) bool {
	t.Helper()

	_, err := client.GetPolicy(context.TODO(), &iam.GetPolicyInput{
		PolicyArn: &policyArn,
	})

	return err == nil
}

func fetchPolicyProps(t *testing.T, client *iam.Client, policyArn string) IAMPolicyProps {
	t.Helper()

	props := IAMPolicyProps{}

	output, err := client.GetPolicy(context.TODO(), &iam.GetPolicyInput{
		PolicyArn: &policyArn,
	})
	require.NoError(t, err, "Failed to get policy")

	if output.Policy != nil {
		if output.Policy.PolicyName != nil {
			props.Name = *output.Policy.PolicyName
		}
		if output.Policy.Arn != nil {
			props.Arn = *output.Policy.Arn
		}
		if output.Policy.Path != nil {
			props.Path = *output.Policy.Path
		}
		if output.Policy.Description != nil {
			props.Description = *output.Policy.Description
		}
	}

	return props
}

func mustEnv(t *testing.T, key string) string {
	t.Helper()
	v := strings.TrimSpace(os.Getenv(key))
	require.NotEmpty(t, v, "Missing required environment variable %s", key)
	return v
}

func roleExists(t *testing.T, client *iam.Client, roleName string) bool {
	t.Helper()

	_, err := client.GetRole(context.TODO(), &iam.GetRoleInput{
		RoleName: &roleName,
	})

	return err == nil
}

func stringPtr(s string) *string {
	return &s
}
