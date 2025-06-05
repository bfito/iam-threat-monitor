#!/bin/bash
# Interactive IAM user deletion script

# === Fetch IAM users from default profile (to list candidates) ===
echo "\nFetching IAM users (from default profile)..."
readarray -t USERS < <(aws iam list-users --profile default --query 'Users[*].UserName' --output text 2>/dev/null | tr '\t' '\n')
if [ ${#USERS[@]} -eq 0 ]; then
  echo "No IAM users found."
  exit 1
fi

# === Define protected IAM usernames ===
PROTECTED_USERS=(
  "admin-user"
  # "critical-user-to-be-added"
)

echo "\nAvailable IAM users to delete:"
for i in "${!USERS[@]}"; do
  username="${USERS[$i]}"
  is_protected=false
  for protected in "${PROTECTED_USERS[@]}"; do
    if [[ "$username" == "$protected" ]]; then
      is_protected=true
      break
    fi
  done
  if $is_protected; then
    printf "%3d) \e[31m%s (protected - cannot be deleted)\e[0m\n" $((i + 1)) "$username"
  else
    printf "%3d) %s\n" $((i + 1)) "$username"
  fi
done

read -p "Enter the number of the user to delete: " USER_INDEX
if ! [[ "$USER_INDEX" =~ ^[0-9]+$ ]] || [ "$USER_INDEX" -lt 1 ] || [ "$USER_INDEX" -gt "${#USERS[@]}" ]; then
  echo "Invalid selection. Exiting."
  exit 1
fi

TEST_USERNAME="${USERS[$((USER_INDEX - 1))]}"
for protected in "${PROTECTED_USERS[@]}"; do
  if [[ "$TEST_USERNAME" == "$protected" ]]; then
    echo "Refusing to delete protected user '$TEST_USERNAME'."
    exit 1
  fi
done

# === Fetch all configured profiles ===
echo "\nFetching available AWS CLI profiles..."
readarray -t PROFILES < <(aws configure list-profiles)
if [ ${#PROFILES[@]} -eq 0 ]; then
  echo "No AWS CLI profiles found. Run 'aws configure' first."
  exit 1
fi

# === Prompt for profile to use ===
echo "\nAvailable AWS CLI profiles:"
for i in "${!PROFILES[@]}"; do
  printf "%3d) %s\n" $((i + 1)) "${PROFILES[$i]}"
  done
read -p "Select profile number to use: " PROFILE_INDEX
if ! [[ "$PROFILE_INDEX" =~ ^[0-9]+$ ]] || [ "$PROFILE_INDEX" -lt 1 ] || [ "$PROFILE_INDEX" -gt "${#PROFILES[@]}" ]; then
  echo "Invalid profile selection. Exiting."
  exit 1
fi
AWS_PROFILE_NAME="${PROFILES[$((PROFILE_INDEX - 1))]}"

# === IAM cleanup preview ===
echo "\n=== IAM Cleanup Preview for User: $TEST_USERNAME (Profile: $AWS_PROFILE_NAME) ==="
echo "\nGroups:"
aws iam list-groups-for-user --user-name "$TEST_USERNAME" --profile "$AWS_PROFILE_NAME" --query 'Groups[*].GroupName' --output text

echo "\nAttached Managed Policies:"
aws iam list-attached-user-policies --user-name "$TEST_USERNAME" --profile "$AWS_PROFILE_NAME" --query 'AttachedPolicies[*].PolicyName' --output text

echo "\nInline Policies:"
aws iam list-user-policies --user-name "$TEST_USERNAME" --profile "$AWS_PROFILE_NAME" --output text

echo "\nAccess Keys:"
aws iam list-access-keys --user-name "$TEST_USERNAME" --profile "$AWS_PROFILE_NAME" --query 'AccessKeyMetadata[*].AccessKeyId' --output text

echo ""
read -p "Continue with deletion of user '$TEST_USERNAME'? (y/N): " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "Aborted."
  exit 1
fi

# === Perform Deletion ===
echo "Removing from groups..."
aws iam list-groups-for-user --user-name "$TEST_USERNAME" --profile "$AWS_PROFILE_NAME" --query 'Groups[*].GroupName' --output text | while read group; do
  aws iam remove-user-from-group --user-name "$TEST_USERNAME" --group-name "$group" --profile "$AWS_PROFILE_NAME"
done

echo "Detaching managed policies..."
aws iam list-attached-user-policies --user-name "$TEST_USERNAME" --profile "$AWS_PROFILE_NAME" --query 'AttachedPolicies[*].PolicyArn' --output text | while read policy_arn; do
  aws iam detach-user-policy --user-name "$TEST_USERNAME" --policy-arn "$policy_arn" --profile "$AWS_PROFILE_NAME"
done

echo "Deleting inline policies..."
aws iam list-user-policies --user-name "$TEST_USERNAME" --profile "$AWS_PROFILE_NAME" --output text | while read policy_name; do
  aws iam delete-user-policy --user-name "$TEST_USERNAME" --policy-name "$policy_name" --profile "$AWS_PROFILE_NAME"
done

echo "Deleting login profile (if exists)..."
aws iam delete-login-profile --user-name "$TEST_USERNAME" --profile "$AWS_PROFILE_NAME" 2>/dev/null || true

echo "Deleting access keys..."
aws iam list-access-keys --user-name "$TEST_USERNAME" --profile "$AWS_PROFILE_NAME" --query 'AccessKeyMetadata[*].AccessKeyId' --output text | while read key_id; do
  aws iam delete-access-key --user-name "$TEST_USERNAME" --access-key-id "$key_id" --profile "$AWS_PROFILE_NAME"
done

echo "Deleting user..."
aws iam delete-user --user-name "$TEST_USERNAME" --profile "$AWS_PROFILE_NAME"
echo "User '$TEST_USERNAME' deleted successfully."
