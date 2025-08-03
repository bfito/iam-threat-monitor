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
source "./util/divider.sh"  # <-- Load your divider function
require_username "$1"
USERNAME="$1"

# Centralized redaction wrapper
run_and_redact() {
  "$@" 2>&1 | ./util/sanitize_output.sh
}

print_section "🔧 Creating IAM user"
# run_and_redact ./scripts/iam/create_user.sh "$USERNAME"
./scripts/iam/create_user.sh "$USERNAME"

print_section "🔐 Attaching ChangePassword policy"
run_and_redact ./scripts/iam/add_password_policy.sh "$USERNAME" "IAMThreatMonitorTestGroup"

print_section "🔑 Setting temporary password"
run_and_redact ./scripts/iam/set_temp_password.sh "$USERNAME"



print_section "🚀 Deploying EventBridge rule"
run_and_redact ./scripts/eventbridge/deploy_eventbridge_with_lambda.sh

print_section "✅ Setup complete for user '$USERNAME'"
