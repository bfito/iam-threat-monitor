#!/bin/bash
set -e
source "${BASH_SOURCE%/*}/user_check.sh"
require_username "$1"

TEMP_PASSWORD=$(openssl rand -base64 12)

CREATE_PROFILE_OUTPUT=$(aws iam create-login-profile \
  --user-name "$USERNAME" \
  --password "$TEMP_PASSWORD" \
  --password-reset-required)

echo "$CREATE_PROFILE_OUTPUT" | sed -E \
  -e 's|"UserName": "[^"]+"|"UserName": "'"$USERNAME"'"|' \
  -e 's|"CreateDate": "[^"]+"|"CreateDate": "REDACTED"|' \
  -e 's|"PasswordResetRequired": [^}]+|"PasswordResetRequired": true|'

echo "🔐 Temporary password for '$USERNAME': $TEMP_PASSWORD"
