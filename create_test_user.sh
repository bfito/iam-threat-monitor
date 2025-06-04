#!/bin/bash

# IAM Test User Setup Script for Security Monitoring Demo

TEST_IAM_USERNAME=$1
TEST_IAM_GROUP_NAME="TestSecuredGroup"

if [ -z "$TEST_IAM_USERNAME" ]; then
  echo "Usage: $0 <test-iam-username>"
  exit 1
fi

# Create IAM test user
aws iam create-user --user-name "$TEST_IAM_USERNAME"

# Create test IAM group if it doesn't exist
aws iam get-group --group-name "$TEST_IAM_GROUP_NAME" >/dev/null 2>&1 || \
aws iam create-group --group-name "$TEST_IAM_GROUP_NAME"

# Add test user to test group
aws iam add-user-to-group \
  --user-name "$TEST_IAM_USERNAME" \
  --group-name "$TEST_IAM_GROUP_NAME"

# Attach a read-only policy to the test group
aws iam attach-group-policy \
  --group-name "$TEST_IAM_GROUP_NAME" \
  --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess

# Create login profile to simulate login (triggers CloudTrail ConsoleLogin)
aws iam create-login-profile \
  --user-name "$TEST_IAM_USERNAME" \
  --password 'TempPassword123!' \ #This password is no longer valid. 
  --password-reset-required

echo "✅ Test IAM user '$TEST_IAM_USERNAME' created and added to group '$TEST_IAM_GROUP_NAME'."
echo "🔐 Temporary password set. Assign MFA via AWS Console if required."
