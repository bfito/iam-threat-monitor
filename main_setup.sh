#!/bin/bash
set -e
source "${BASH_SOURCE%/*}/user_check.sh"
require_username "$1"

echo "🔧 Creating IAM user..."
./create_user.sh "$USERNAME"

echo "🔐 Attaching MFA policy..."
./attach_mfa_policy.sh "$USERNAME"

echo "🔐 Attaching ChangePassword policy..."
./add_password_policy.sh "$USERNAME"

echo "🔑 Setting temporary password..."
./set_temp_password.sh "$USERNAME"

echo " Deployed Eventbridge rule..."
./deploy_eventbridge_rule.sh

echo "✅ Setup complete for user '$USERNAME'."
