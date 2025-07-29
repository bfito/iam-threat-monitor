### scripts/eventbridge/deploy_eventbridge_with_lambda.sh (updated)
#!/bin/bash
set -e

echo "🚀 Deploying EventBridge rule with Lambda target..."

DIR="$(dirname "$0")"

# 1. Create the rule
"$DIR/create_eventbridge_rule.sh"

# 2. Zip Lambda and deploy
"$DIR/../lambda/zip_lambda.sh"
"$DIR/../lambda/create_lambda.sh"

# 3. Attach permissions
"$DIR/attach_lambda_permissions.sh"

# 4. Add Lambda as target
aws events put-targets \
  --rule ConsoleLoginWithoutMFA \
  --targets "Id"="1","Arn"="arn:aws:lambda:$(aws configure get region):$(aws sts get-caller-identity --query Account --output text):function:LogMFAEventsLambda"

echo "✅ EventBridge rule now triggers Lambda on ConsoleLoginWithoutMFA"
