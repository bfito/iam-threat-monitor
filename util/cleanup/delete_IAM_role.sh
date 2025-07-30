#!/bin/bash
set -e

USER_NAME="$1"
RULE_NAME="ConsoleLoginWithoutMFA"
LOG_GROUP="/aws/events/NonMFAConsoleLogins"
LAMBDA_NAME="LogMFAEventsLambda"
ROLE_NAME="LambdaBasicExecutionRole"

# Delete IAM Role
ROLE_NAME="LambdaBasicExecutionRole"
echo "🎭 Cleaning up IAM role: $ROLE_NAME"
aws iam detach-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" || true

aws iam delete-role --role-name "$ROLE_NAME" || true

echo "✅ Cleanup complete!"
