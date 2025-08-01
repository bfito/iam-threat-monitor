#!/bin/bash

# Redact sensitive AWS identifiers in JSON/text streams
sed -E \
  -e 's|arn:aws:[^"]+|arn:aws:REDACTED|g' \
  -e 's|"UserName": "[^"]+"|"UserName": "REDACTED"|g' \
  -e 's|"CreateDate": "[^"]+"|"CreateDate": "REDACTED"|g' \
  -e 's|"RevisionId": "[^"]+"|"RevisionId": "REDACTED"|g' \
  -e 's|"AccessKeyId": "[^"]+"|"AccessKeyId": "REDACTED"|g' \
  -e 's|"SecretAccessKey": "[^"]+"|"SecretAccessKey": "REDACTED"|g' \
  -e 's|"UserId": "[^"]+"|"UserId": "REDACTED"|g' \
  -e 's|"FunctionArn": "[^"]+"|"FunctionArn": "REDACTED"|g' \
  -e 's|"Role": "arn:[^"]+"|"Role": "REDACTED"|g' \
  -e 's|"Resource": "arn:[^"]+"|"Resource": "REDACTED"|g' \
  -e 's|"Account": "[0-9]{12}"|"Account": "REDACTED"|g' \
  -e 's|[0-9]{12}|REDACTED_ACCOUNT_ID|g' \
  -e 's|"Password": "[^"]+"|"Password": "REDACTED"|g' \
  -e 's|lyXduMkO4ylOrcA1!|REDACTED_PASSWORD|g' \
  -e 's|arn:aws:iam::[0-9]+:user/[^"]+|REDACTED_USER|g'
