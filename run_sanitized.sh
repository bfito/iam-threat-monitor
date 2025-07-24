#!/bin/bash

# Read from stdin and redact sensitive fields
sed -E \
  -e 's|"UserId": "[^"]+"|"UserId": "REDACTED"|' \
  -e 's|"Arn": "[^"]+"|"Arn": "arn:aws:iam::ACCOUNT-ID-REDACTED:user/REDACTED"|' \
  -e 's|arn:aws:iam::[0-9]+:|arn:aws:iam::ACCOUNT-ID:|' \
  -e 's|"CreateDate": "[^"]+"|"CreateDate": "REDACTED"|' \
  -e 's|"RuleArn": "arn:aws:events:[^"]+"|"RuleArn": "arn:aws:events:REGION:ACCOUNT-ID-REDACTED:rule/REDACTED"|'
