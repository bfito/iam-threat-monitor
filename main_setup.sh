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
TEMP_PASSWORD=$(openssl rand -base64 12)
CREATE_PROFILE_OUTPUT=$(aws iam create-login-profile \
  --user-name "$USERNAME" \
  --password "$TEMP_PASSWORD" \
  --password-reset-required)

echo "🔐 Attaching ChangePassword policy..."
aws iam put-user-policy \
  --user-name "$USERNAME" \
  --policy-name "ChangePasswordPolicy-$USERNAME" \
  --policy-document file://change_password_policy.json

# Redact sensitive login profile info
echo "$CREATE_PROFILE_OUTPUT" | sed -E \
  -e 's|"UserName": "[^"]+"|"UserName": "'"$USERNAME"'"|' \
  -e 's|"CreateDate": "[^"]+"|"CreateDate": "REDACTED"|' \
  -e 's|"PasswordResetRequired": [^}]+|"PasswordResetRequired": true|'

echo "🔐 Temporary password for '$USERNAME': $TEMP_PASSWORD"

# Check if the EventBridge rule already exists
if ! aws events list-rules --name-prefix ConsoleLoginWithoutMFA | grep -q "ConsoleLoginWithoutMFA"; then
  echo "📡 Creating EventBridge rule to detect logins without MFA..."
  aws events put-rule \
    --name ConsoleLoginWithoutMFA \
    --event-pattern file://eventbridge_rule_console_login.json \
    --event-bus-name default

  if [[ $? -eq 0 ]]; then
    echo "✅ EventBridge rule created successfully."
  else
    echo "❌ Failed to create EventBridge rule."
  fi
else
  echo "ℹ️ EventBridge rule already exists. Skipping creation."
fi

echo "✅ Done. User '$USERNAME' created, MFA policy applied, and login monitoring rule checked."

