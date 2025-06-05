#!/bin/bash
# Secure script to create an IAM test user, assign to group, attach policy, and remind about MFA

TEST_USER_NAME=$1
TEST_GROUP_NAME="MFAEnforcedTestGroup"

if [ -z "$TEST_USER_NAME" ]; then
  echo "Usage: $0 <test-user-name>"
  exit 1
fi

# === Variables ===
TEST_USERNAME=$1
TEST_GROUP_NAME="TestSecuredGroup"
AWS_PROFILE_NAME="my-secure-profile"  # <-- Make sure to configure this profile using `aws configure --profile my-secure-profile`

# === Create user ===
aws iam create-user \
  --user-name "$TEST_USERNAME" \
  --profile "$AWS_PROFILE_NAME"

# === Create group if it doesn't exist ===
aws iam get-group \
  --group-name "$TEST_GROUP_NAME" \
  --profile "$AWS_PROFILE_NAME" > /dev/null 2>&1

if [ $? -ne 0 ]; then
  aws iam create-group \
    --group-name "$TEST_GROUP_NAME" \
    --profile "$AWS_PROFILE_NAME"
fi

# === Attach ReadOnlyAccess policy to the group ===
aws iam attach-group-policy \
  --group-name "$TEST_GROUP_NAME" \
  --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess \
  --profile "$AWS_PROFILE_NAME"

# === Add user to group ===
aws iam add-user-to-group \
  --user-name "$TEST_USERNAME" \
  --group-name "$TEST_GROUP_NAME" \
  --profile "$AWS_PROFILE_NAME"

# === Output MFA reminder ===
echo "✅ Test IAM user '$TEST_USERNAME' created and added to group '$TEST_GROUP_NAME'."
echo "🔐 Temporary password must be set manually via AWS Console if needed."
echo "🚨 Don’t forget to enforce or assign MFA for '$TEST_USERNAME'."
