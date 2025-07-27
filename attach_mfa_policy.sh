#!/bin/bash
set -e
source "${BASH_SOURCE%/*}/user_check.sh"
require_username "$1"

POLICY_NAME="MFAEnforcedPolicy-$USERNAME-$(date +%s)"

aws iam put-user-policy \
  --user-name "$USERNAME" \
  --policy-name "$POLICY_NAME" \
  --policy-document file://policies/mfa_enforced_policy.json

echo "✅ MFA policy attached: $POLICY_NAME"