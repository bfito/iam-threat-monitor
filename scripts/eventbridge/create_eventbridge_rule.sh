#!/bin/bash
set -e

RULE_NAME="ConsoleLoginWithoutMFA"
EVENT_PATTERN_FILE="eventbridge_rule_console_login.json"
LOG_GROUP_NAME="/aws/events/NonMFAConsoleLogins"

# Create EventBridge rule if it doesn't exist
if aws events list-rules --name-prefix "$RULE_NAME" | grep -q "$RULE_NAME"; then
  echo "ℹ️  EventBridge rule '$RULE_NAME' already exists. Skipping creation."
else
  echo "📡 Creating EventBridge rule to detect logins without MFA..."
  RULE_OUTPUT=$(aws events put-rule \
    --name "$RULE_NAME" \
    --event-pattern "file://$EVENT_PATTERN_FILE" \
    --event-bus-name default)

  if [[ -f "$(dirname "$0")/run_sanitized.sh" ]]; then
    echo "$RULE_OUTPUT" | "$(dirname "$0")/run_sanitized.sh"
  else
    echo "$RULE_OUTPUT"
  fi
  echo "✅ EventBridge rule created successfully."
fi
