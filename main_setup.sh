#!/bin/bash

# -----------------------------
# Usage: ./main_setup.sh <username> [policy-name]
# If no policy name is given, a unique one will be generated.
# -----------------------------

# 1. Get username from first argument
USERNAME="$1"

# 2. If username not given, exit
if [[ -z "$USERNAME" ]]; then
  echo "❌ Error: You must provide a username."
  echo "Usage: ./main_setup.sh <username> [policy-name]"
  exit 1
fi

# 3. Use provided policy name or generate a unique one
if [[ -z "$2" ]]; then
  TIMESTAMP=$(date +%s)
  POLICY_NAME="MFAEnforcedPolicy-${USERNAME}-${TIMESTAMP}"
else
  POLICY_NAME="$2"
fi

echo "🔧 Creating IAM user: $USERNAME"
aws iam create-user --user-name "$USERNAME"

echo "🔐 Attaching MFA enforcement policy: $POLICY_NAME"
aws iam put-user-policy \
  --user-name "$USERNAME" \
  --policy-name "$POLICY_NAME" \
  --policy-document file://mfa_enforced_policy.json

echo "🔑 Creating login profile (temporary password)"
aws iam create-login-profile \
  --user-name "$USERNAME" \
  --password 'TempPass123!' \
  --password-reset-required

echo "✅ Done. User '$USERNAME' created and policy '$POLICY_NAME' applied."

