#!/bin/bash
set -e

USERNAME=$1

if [[ -z "$USERNAME" ]]; then
  echo "❌ Error: No username provided."
  echo "Usage: ./main_setup.sh <username>"
  exit 1
fi

POLICY_NAME="MFAEnforcedPolicy-$USERNAME-$(date +%s)"

echo "🔧 Creating IAM user: $USERNAME..."
CREATE_USER_OUTPUT=$(aws iam create-user --user-name "$USERNAME")

# Redact sensitive info before displaying
echo "$CREATE_USER_OUTPUT" | sed -E \
  -e 's|"UserId": "[^"]+"|"UserId": "REDACTED"|' \
  -e 's|"Arn": "[^"]+"|"Arn": "arn:aws:iam::ACCOUNT-ID-REDACTED:user/'"$USERNAME"'"|' \
  -e 's|arn:aws:iam::[0-9]+:|arn:aws:iam::ACCOUNT-ID:|'

echo "🔐 Attaching MFA enforcement policy: $POLICY_NAME"
aws iam put-user-policy \
  --user-name "$USERNAME" \
  --policy-name "$POLICY_NAME" \
  --policy-document file://mfa_enforced_policy.json

echo "🔑 Creating login profile (temporary password)..."
CREATE_PROFILE_OUTPUT=$(aws iam create-login-profile \
  --user-name "$USERNAME" \
  --password "TempPass123!" \
  --password-reset-required)

echo "$CREATE_PROFILE_OUTPUT" | sed -E \
  -e 's|"UserName": "[^"]+"|"UserName": "'"$USERNAME"'"|' \
  -e 's|"CreateDate": "[^"]+"|"CreateDate": "REDACTED"|' \
  -e 's|"PasswordResetRequired": [^}]+|"PasswordResetRequired": true|'

echo "✅ Done. User '$USERNAME' created and policy '$POLICY_NAME' applied."

