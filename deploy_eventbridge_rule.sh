#!/bin/bash
set -e

RULE_NAME="ConsoleLoginWithoutMFA"
EVENT_PATTERN_FILE="eventbridge_rule_console_login.json"

# Check if the EventBridge rule already exists
if aws events list-rules --name-prefix "$RULE_NAME" | grep -q "$RULE_NAME"; then
  echo "ℹ️  EventBridge rule '$RULE_NAME' already exists. Skipping creation."
else
  echo "📡 Creating EventBridge rule to detect logins without MFA..."
  RULE_OUTPUT=$(aws events put-rule \
    --name "$RULE_NAME" \
    --event-pattern "file://$EVENT_PATTERN_FILE" \
    --event-bus-name default)

  # Sanitize and display output (e.g., hide account number in ARN)
  if [[ -f "$(dirname "$0")/sanitize_output.sh" ]]; then
    echo "$RULE_OUTPUT" | "$(dirname "$0")/sanitize_output.sh"
  else
    echo "$RULE_OUTPUT"  # fallback if sanitize script is missing
  fi

  echo "✅ EventBridge rule created successfully."
fi
