#!/bin/bash
set -e

RULE_NAME="ConsoleLoginWithoutMFA"
EVENT_PATTERN_FILE="eventbridge_rule_console_login.json"
LOG_GROUP_NAME="/aws/events/NonMFAConsoleLogins"

# Attach CloudWatch Logs as a target
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
LOG_GROUP_ARN="arn:aws:logs:us-east-1:${ACCOUNT_ID}:log-group:${LOG_GROUP_NAME}"

echo "🎯 Attaching CloudWatch Logs as target to rule..."
aws events put-targets \
  --rule "$RULE_NAME" \
  --targets "[{
    \"Id\": \"CloudWatchTarget\",
    \"Arn\": \"${LOG_GROUP_ARN}\"
  }]"
echo "✅ CloudWatch target attached to EventBridge rule."
