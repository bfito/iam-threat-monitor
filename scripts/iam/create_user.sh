#!/bin/bash
set -e
source "${BASH_SOURCE%/*}/user_check.sh"
require_username "$1"

USERNAME="$1"
if aws iam get-user --user-name "$USERNAME" &>/dev/null; then
    echo "⚠️ User '$USERNAME' already exists. Skipping creation."
else
    echo "🔧 Creating IAM user: $USERNAME..."
    CREATE_USER_OUTPUT=$(aws iam create-user --user-name "$USERNAME")
    echo "$CREATE_USER_OUTPUT" | ./run_sanitized.sh
fi