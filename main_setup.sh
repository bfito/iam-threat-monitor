#!/bin/bash
set -e
source "./scripts/iam/user_check.sh"
require_username "$1"
USERNAME="$1"

echo "🔧 Creating IAM user..."
./scripts/iam/create_user.sh "$USERNAME"

echo "🔐 Attaching ChangePassword policy..."
./scripts/iam/add_password_policy.sh "$USERNAME"

echo "🔑 Setting temporary password..."
./scripts/iam/set_temp_password.sh "$USERNAME"

echo "🚀 Deploying EventBridge rule..."
./scripts/eventbridge/deploy_eventbridge_with_logs.sh

echo "✅ Setup complete for user '$USERNAME'."
