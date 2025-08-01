#!/bin/bash
set -e

FUNCTION_NAME="LogMFAEventsLambda"

echo "🧪 Invoking Lambda '$FUNCTION_NAME' to simulate non-MFA login..."

aws lambda invoke \
  --function-name "$FUNCTION_NAME" \
  --payload '{
    "version": "0",
    "id": "demo456",
    "detail-type": "AWS Console Sign In via CloudTrail",
    "source": "aws.signin",
    "account": "123456789012",
    "time": "2025-07-31T18:00:00Z",
    "region": "us-east-1",
    "resources": [],
    "detail": {
      "eventName": "ConsoleLogin",
      "additionalEventData": {
        "MFAUsed": "No"
      }
    }
  }' \
  /tmp/lambda_test_output.json \
  --cli-binary-format raw-in-base64-out

echo "📄 Lambda response written to: /tmp/lambda_test_output.json"