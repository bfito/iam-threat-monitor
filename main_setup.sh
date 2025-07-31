#!/bin/bash

cat << "EOF"
 ______     __     __     ______        __     ______     __    __        _____     ______     __    __     ______    
/\  __ \   /\ \  _ \ \   /\  ___\      /\ \   /\  __ \   /\ "-./  \      /\  __-.  /\  ___\   /\ "-./  \   /\  __ \   
\ \  __ \  \ \ \/ ".\ \  \ \___  \     \ \ \  \ \  __ \  \ \ \-./\ \     \ \ \/\ \ \ \  __\   \ \ \-./\ \  \ \ \/\ \  
 \ \_\ \_\  \ \__/".~\_\  \/\_____\     \ \_\  \ \_\ \_\  \ \_\ \ \_\     \ \____-  \ \_____\  \ \_\ \ \_\  \ \_____\ 
  \/_/\/_/   \/_/   \/_/   \/_____/      \/_/   \/_/\/_/   \/_/  \/_/      \/____/   \/_____/   \/_/  \/_/   \/_____/ 
                                                                                                                    
EOF
echo ""

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
./scripts/eventbridge/deploy_eventbridge_with_lambda.sh

echo "✅ Setup complete for user '$USERNAME'."
