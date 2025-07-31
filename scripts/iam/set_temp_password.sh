#!/bin/bash
set -e

# Load helper and validate input
source "${BASH_SOURCE%/*}/user_check.sh"
require_username "$1"

USERNAME="$1"

# Generate secure random temp password
TEMP_PASSWORD="$(openssl rand -base64 16 | tr -dc 'A-Za-z0-9!@#%&*_' | head -c14)A1!"

# Check if the login profile already exists
if aws iam get-login-profile --user-name "$USERNAME" &>/dev/null; then
  echo "⚠️ Login profile already exists for '$USERNAME'. Skipping password creation."
else
  echo "🔐 Creating login profile for '$USERNAME'..."

  CREATE_PROFILE_OUTPUT=$(aws iam create-login-profile \
    --user-name "$USERNAME" \
    --password "$TEMP_PASSWORD" \
    --password-reset-required)

  # Redact sensitive parts from output for logging or script display
  echo "$CREATE_PROFILE_OUTPUT" | sed -E \
    -e 's|"UserName": "[^"]+"|"UserName": "'"$USERNAME"'"|' \
    -e 's|"CreateDate": "[^"]+"|"CreateDate": "REDACTED"|' \
    -e 's|"PasswordResetRequired": [^}]+|"PasswordResetRequired": true|'

  echo "✅ Temporary password for '$USERNAME': $TEMP_PASSWORD"
fi
