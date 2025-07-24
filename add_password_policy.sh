#!/bin/bash
set -e
source "${BASH_SOURCE%/*}/user_check.sh"
require_username "$1"

aws iam put-user-policy \
  --user-name "$USERNAME" \
  --policy-name "AllowPasswordChange" \
  --policy-document file://change_password_policy.json

echo "✅ ChangePassword policy attached to $USERNAME"