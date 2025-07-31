#!/bin/bash
set -e

echo "🚀 Deploying EventBridge rule with Lambda target..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 1. Create the rule
"$SCRIPT_DIR/create_eventbridge_rule.sh"

# 2. Zip Lambda and deploy
"$REPO_ROOT/util/zip_lambda.sh"
"$REPO_ROOT/scripts/lambda/create_lambda.sh"

# 3. Attach permissions
"$SCRIPT_DIR/attach_lambda_permissions.sh"

# 4. Add Lambda as target
aws events put-targets \
  --rule ConsoleLoginWithoutMFA \
  --targets "Id"="1","Arn"="arn:aws:lambda:$(aws configure get region):$(aws sts get-caller-identity --query Account --output text):function:LogMFAEventsLambda"

echo "✅ EventBridge rule now triggers Lambda on ConsoleLoginWithoutMFA"
