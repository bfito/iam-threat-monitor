### scripts/lambda/index.js
exports.handler = async (event) => {
  console.log("🚨 Event received:", JSON.stringify(event, null, 2));
  return {
    statusCode: 200,
    body: JSON.stringify('Event processed')
  };
};

### scripts/lambda/zip_lambda.sh
#!/bin/bash
set -e

ZIP_NAME="lambda_function.zip"
echo "📦 Zipping Lambda function..."
cd "$(dirname "$0")"
zip -r "$ZIP_NAME" index.js
cd -
echo "✅ Lambda zipped as $ZIP_NAME"

### scripts/lambda/create_lambda.sh
#!/bin/bash
set -e

LAMBDA_NAME="LogMFAEventsLambda"
ROLE_NAME="LambdaBasicExecutionRole"
ZIP_FILE="scripts/lambda/lambda_function.zip"

# Create IAM role for Lambda
aws iam create-role \
  --role-name "$ROLE_NAME" \
  --assume-role-policy-document 'file://<(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
)'

# Attach basic execution policy
aws iam attach-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# Wait for IAM propagation
sleep 10

# Create the Lambda function
aws lambda create-function \
  --function-name "$LAMBDA_NAME" \
  --runtime nodejs18.x \
  --role "arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/$ROLE_NAME" \
  --handler index.handler \
  --zip-file "fileb://$ZIP_FILE"

echo "✅ Lambda function created: $LAMBDA_NAME"

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
