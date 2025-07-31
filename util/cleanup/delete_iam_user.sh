#!/bin/bash
set -e

# Validate input
if [ -z "$1" ]; then
  echo "❌ Please provide the IAM username to delete."
  echo "Usage: $0 <username>"
  exit 1
fi

USER_NAME="$1"
RULE_NAME="ConsoleLoginWithoutMFA"
LOG_GROUP="/aws/events/NonMFAConsoleLogins"
LAMBDA_NAME="LogMFAEventsLambda"
ROLE_NAME="LambdaBasicExecutionRole"

echo "🧹 Starting cleanup for user: $USER_NAME"

# Delete IAM user
if aws iam get-user --user-name "$USER_NAME" &>/dev/null; then
  echo "👤 Deleting IAM user: $USER_NAME"
  aws iam delete-login-profile --user-name "$USER_NAME" || true
  aws iam detach-user-policy --user-name "$USER_NAME" --policy-arn arn:aws:iam::aws:policy/IAMUserChangePassword || true
  aws iam delete-user --user-name "$USER_NAME"
else
  echo "ℹ️ User '$USER_NAME' not found. Skipping."
fi