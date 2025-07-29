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

