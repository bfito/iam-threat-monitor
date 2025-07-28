#!/bin/bash
set -e

RULE_NAME="ConsoleLoginWithoutMFA"
EVENT_PATTERN_FILE="eventbridge_rule_console_login.json"
LOG_GROUP_NAME="/aws/events/NonMFAConsoleLogins"

# Create CloudWatch log group if it doesn't exist
if ! aws logs describe-log-groups --log-group-name-prefix "$LOG_GROUP_NAME" | grep -q "$LOG_GROUP_NAME"; then
  echo "🪵 Creating CloudWatch log group..."
  aws logs create-log-group --log-group-name "$LOG_GROUP_NAME"
fi

# Allow EventBridge to put logs
aws logs put-resource-policy \
  --policy-name "AllowEventBridgeToWriteLogs" \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {"Service": "events.amazonaws.com"},
      "Action": "logs:PutLogEvents",
      "Resource": "*"
    }]
  }' >/dev/null