#!/bin/bash

# Sanitize CLI or AWS JSON output to redact sensitive info
sed -E \
  -e 's|"UserId": "[^"]+"|"UserId": "REDACTED"|g' \
  -e 's|"CreateDate": "[^"]+"|"CreateDate": "REDACTED"|g' \
  -e 's|arn:aws:iam::[0-9]+:user/[^"]+|REDACTED_USER|g' \
  -e 's|"Password": "[^"]+"|"Password": "REDACTED"|g' \
  -e 's|lyXduMkO4ylOrcA1!|REDACTED_PASSWORD|g' \
  -e 's|"FunctionArn": "[^"]+"|"FunctionArn": "REDACTED"|g' \
  -e 's|"RevisionId": "[^"]+"|"RevisionId": "REDACTED"|g' \
  -e 's|"Resource": "arn:[^"]+"|"Resource": "REDACTED"|g' \
  -e 's|"Role": "arn:[^"]+"|"Role": "REDACTED"|g' \
  -e 's|arn:aws:[^"]+|arn:aws:REDACTED|g' \
  -e 's|"Account": "[0-9]{12}"|"Account": "REDACTED"|g' \
  -e 's|[0-9]{12}|REDACTED_ACCOUNT_ID|g'

# Comments for reference:
# - scripts/iam/create_user.sh: UserName, UserId, CreateDate, arn:aws:iam::user
# - scripts/iam/set_temp_password.sh: Password
# - scripts/lambda/create_lambda.sh: FunctionArn, RevisionId
# - scripts/eventbridge/attach_lambda_permissions.sh: Resource
# - scripts/eventbridge/deploy_eventbridge_with_lambda.sh: Role
# - util/cleanup/delete_iam_user.sh: arn:aws
# - generic: Account ID
