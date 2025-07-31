#!/bin/bash
set -e

USER_NAME="$1"
RULE_NAME="ConsoleLoginWithoutMFA"
LOG_GROUP="/aws/events/NonMFAConsoleLogins"
LAMBDA_NAME="LogMFAEventsLambda"
ROLE_NAME="LambdaBasicExecutionRole"

# Delete CloudWatch Log Group
LOG_GROUP="/aws/events/NonMFAConsoleLogins"
echo "🗑️ Deleting CloudWatch Log Group: $LOG_GROUP"
aws logs delete-log-group --log-group-name "$LOG_GROUP" || true