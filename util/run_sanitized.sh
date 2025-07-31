#!/bin/bash

# Read from stdin and redact sensitive fields
sed -E \
  -e 's|arn:aws:[^"]+|arn:aws:REDACTED|g' \
  -e 's|"UserName": "[^"]+"|"UserName": "REDACTED"|' \
  -e 's|"CreateDate": "[^"]+"|"CreateDate": "REDACTED"|' \
  -e 's|"RevisionId": "[^"]+"|"RevisionId": "REDACTED"|' \
  -e 's|"AccessKeyId": "[^"]+"|"AccessKeyId": "REDACTED"|' \
  -e 's|"SecretAccessKey": "[^"]+"|"SecretAccessKey": "REDACTED"|' \
  -e 's|"Account": "[0-9]+"|"Account": "REDACTED"|' \
  -e 's|"Resource": "arn:[^"]+"|"Resource": "REDACTED"|' \
  -e 's|arn:aws:iam::[0-9]+:user/[^"]+|REDACTED_USER|g'