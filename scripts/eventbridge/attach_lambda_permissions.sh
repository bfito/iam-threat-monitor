### scripts/eventbridge/attach_lambda_permissions.sh
#!/bin/bash
set -e

LAMBDA_NAME="LogMFAEventsLambda"
RULE_NAME="ConsoleLoginWithoutMFA"

# Grant EventBridge permission to invoke Lambda
aws lambda add-permission \
  --function-name "$LAMBDA_NAME" \
  --statement-id "AllowExecutionFromEventBridge" \
  --action "lambda:InvokeFunction" \
  --principal events.amazonaws.com \
  --source-arn "arn:aws:events:$(aws configure get region):$(aws sts get-caller-identity --query Account --output text):rule/$RULE_NAME"

echo "✅ Lambda permission granted to EventBridge"

