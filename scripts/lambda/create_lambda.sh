#!/bin/bash
set -e

echo "🛠️ Creating Lambda function and IAM role..."

# Dynamically find path to repo and zip file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ZIP_FILE="$SCRIPT_DIR/lambda_function.zip"
ROLE_NAME="LogMFAEventsLambdaRole"
FUNCTION_NAME="LogMFAEventsLambda"

# ✅ STEP 1: Create a temporary file with trust policy JSON
ASSUME_ROLE_POLICY_FILE=$(mktemp)
cat > "$ASSUME_ROLE_POLICY_FILE" <<EOF
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

# ✅ STEP 2: Check if role exists before creating
if aws iam get-role --role-name "$ROLE_NAME" &>/dev/null; then
  echo "ℹ️ IAM role '$ROLE_NAME' already exists. Skipping creation."
else
  aws iam create-role \
    --role-name "$ROLE_NAME" \
    --assume-role-policy-document "file://$ASSUME_ROLE_POLICY_FILE"
  echo "✅ IAM role '$ROLE_NAME' created."
fi

# ✅ STEP 3: Clean up the temp file
rm -f "$ASSUME_ROLE_POLICY_FILE"

# STEP 4: Attach basic Lambda execution policy
aws iam attach-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# STEP 5: Wait a few seconds for IAM propagation
echo "⏳ Waiting for IAM role to propagate..."
sleep 10

# STEP 6: Create the Lambda function
if aws lambda get-function --function-name "$FUNCTION_NAME" &>/dev/null; then
  echo "ℹ️ Lambda function '$FUNCTION_NAME' already exists. Skipping creation."
else
  aws lambda create-function \
    --function-name "$FUNCTION_NAME" \
    --runtime nodejs18.x \
    --role "arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/$ROLE_NAME" \
    --handler index.handler \
    --zip-file "fileb://$ZIP_FILE"

  echo "✅ Lambda function '$FUNCTION_NAME' created successfully and is now being initialized by AWS."
fi

echo "🧪 Invoking test_lambda.sh to initialize logs..."
"$(dirname "$0")/test_lambda.sh"

echo "🏁 Lambda setup complete."