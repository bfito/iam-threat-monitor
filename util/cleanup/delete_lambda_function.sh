#!/bin/bash
set -e

USER_NAME="$1"
RULE_NAME="ConsoleLoginWithoutMFA"
LOG_GROUP="/aws/events/NonMFAConsoleLogins"
LAMBDA_NAME="LogMFAEventsLambda"
ROLE_NAME="LambdaBasicExecutionRole"

# Delete Lambda function
LAMBDA_NAME="LogMFAEventsLambda"
if aws lambda get-function --function-name "$LAMBDA_NAME" &>/dev/null; then
  echo "💣 Deleting Lambda function: $LAMBDA_NAME"
  aws lambda delete-function --function-name "$LAMBDA_NAME"
else
  echo "✅ Lambda $LAMBDA_NAME already deleted or not found."
fi