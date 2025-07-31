#!/bin/bash
set -e

USER_NAME="$1"
RULE_NAME="ConsoleLoginWithoutMFA"
LOG_GROUP="/aws/events/NonMFAConsoleLogins"
LAMBDA_NAME="LogMFAEventsLambda"
ROLE_NAME="LambdaBasicExecutionRole"

# Delete EventBridge rule
RULE_NAME="ConsoleLoginWithoutMFA"
echo "⛔ Deleting EventBridge rule: $RULE_NAME"
aws events remove-targets --rule "$RULE_NAME" --ids "1" || true
aws events delete-rule --name "$RULE_NAME" || true