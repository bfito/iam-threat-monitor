#!/bin/bash
set -e

USERNAME=$1

if [[ -z "$USERNAME" ]]; then
  echo "❌ Error: No username provided."
  echo "Usage: ./create_test_user.sh <username>"
  exit 1
fi

echo "🔧 Creating IAM user: $USERNAME..."
CREATE_USER_OUTPUT=$(aws iam create-user --user-name "$USERNAME")

# Redact sensitive info for safe display
echo "$CREATE_USER_OUTPUT" | sed -E \
  -e 's|"UserId": "[^"]+"|"UserId": "REDACTED"|' \
  -e 's|"Arn": "[^"]+"|"Arn": "arn:aws:iam::ACCOUNT-ID-REDACTED:user/'"$USERNAME"'"|' \
  -e 's|arn:aws:iam::[0-9]+:|arn:aws:iam::ACCOUNT-ID:|'

echo "🔑 Creating login profile with temporary password..."
TEMP_PASSWORD=$(openssl rand -base64 12)
CREATE_PROFILE_OUTPUT=$(aws iam create-login-profile \
  --user-name "$USERNAME" \
  --password "$TEMP_PASSWORD" \
  --password-reset-required)

# Redact output for screenshot-safe sharing
echo "$CREATE_PROFILE_OUTPUT" | sed -E \
  -e 's|"CreateDate": "[^"]+"|"CreateDate": "REDACTED"|' \
  -e 's|"PasswordResetRequired": [^}]+|"PasswordResetRequired": true|'

echo "🔐 Temporary password for '$USERNAME': $TEMP_PASSWORD"

