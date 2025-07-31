#!/bin/bash
set -e

LAMBDA_NAME="LogMFAEventsLambda"
RULE_NAME="ConsoleLoginWithoutMFA"
STATEMENT_ID="AllowExecutionFromEventBridge"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Check if permission already exists
if aws lambda get-policy --function-name "$LAMBDA_NAME" 2>/dev/null | grep -q "$STATEMENT_ID"; then
  echo "ℹ️ Lambda permission '$STATEMENT_ID' already exists. Skipping."
else
  echo "🔐 Attaching permission for EventBridge to invoke Lambda..."

  PERMISSION_OUTPUT=$(aws lambda add-permission \
    --function-name "$LAMBDA_NAME" \
    --statement-id "$STATEMENT_ID" \
    --action "lambda:InvokeFunction" \
    --principal events.amazonaws.com \
    --source-arn "arn:aws:events:$(aws configure get region):$(aws sts get-caller-identity --query Account --output text):rule/$RULE_NAME")

  if [[ -f "$REPO_ROOT/util/run_sanitized.sh" ]]; then
    echo "$PERMISSION_OUTPUT" | "$REPO_ROOT/util/run_sanitized.sh"
  else
    echo "$PERMISSION_OUTPUT"
  fi

  echo "✅ Lambda permission granted to EventBridge."
fi
