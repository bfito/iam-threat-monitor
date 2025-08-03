#!/bin/bash
set -e
source "${BASH_SOURCE%/*}/user_check.sh"

require_username "$1"
USERNAME="$1"
GROUP_NAME="$2"
POLICY_NAME="AllowPasswordChange"

# Validate GROUP_NAME before using it
if [[ -z "$GROUP_NAME" ]]; then
  echo "❌ Error: GROUP_NAME is not defined."
  echo "Usage: $0 <username> <group_name>"
  exit 1
fi

aws iam put-group-policy \
  --group-name "$GROUP_NAME" \
  --policy-name "$POLICY_NAME" \
  --policy-document file://policies/change_password_policy.json

echo "✅ Policy '$POLICY_NAME' attached to group '$GROUP_NAME'."
