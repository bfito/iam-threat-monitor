# IAM Threat Monitor Demo

This project sets up a secure IAM environment in AWS with enforced password policies and login monitoring using EventBridge and Lambda. It includes scripts to automate setup and teardown for safe testing.

## 📦 Features

- ✅ Password policy enforcement (complexity, expiration)
- ✅ IAM user creation with temporary password
- ✅ EventBridge rule to detect non-MFA console logins
- ✅ Lambda function to log those events
- ✅ CloudWatch Logs group to store the events
- ✅ Fully scriptable setup and cleanup

## 📁 File Structure

```
.
├── main_setup.sh
├── policies
│   ├── change_password_policy.json
│   └── eventbridge_rule_console_login.json
├── scripts
│   ├── eventbridge
│   │   ├── attach_lambda_permissions.sh
│   │   ├── create_eventbridge_rule.sh
│   │   ├── create_log_group.sh
│   │   └── deploy_eventbridge_with_lambda.sh
│   ├── iam
│   │   ├── add_password_policy.sh
│   │   ├── create_user.sh
│   │   ├── set_temp_password.sh
│   │   └── user_check.sh
│   └── lambda
│       ├── create_lambda.sh
│       └── index.js
├── util
│   ├── run_sanitized.sh
│   └── zip_lambda.sh
└── README.md
```

## 🚀 How to Run

1. Make sure your AWS CLI is configured and has sufficient permissions.

2. Run the setup script:

```bash
chmod +x main_setup.sh
./main_setup.sh demo-user
```

This will:
- Apply IAM password policy
- Create IAM user `demo-user`
- Set a temporary password
- Deploy EventBridge rule to catch non-MFA logins
- Create CloudWatch log group
- Zip, deploy, and connect a Lambda function that logs the login event

## 🔍 How to View Login Logs

Logins **without MFA** will trigger the EventBridge rule, which triggers the Lambda. That Lambda logs the raw event to **CloudWatch Logs** under:

```
/aws/lambda/LogMFAEventsLambda
```

To view the logs:
```bash
aws logs describe-log-groups
aws logs get-log-events --log-group-name /aws/lambda/LogMFAEventsLambda --log-stream-name <YOUR_STREAM_NAME>
```
Or view in the AWS Console under **CloudWatch > Log groups > /aws/lambda/LogMFAEventsLambda**

---

## 🧹 Cleanup
To remove all resources created by this project, run:
```bash
./cleanup.sh
```

This will delete:
- IAM user
- Log groups
- Lambda function
- EventBridge rule and target
- IAM role used by Lambda

## 💸 Cost
Everything used in this project is eligible for **AWS Free Tier**:
- EventBridge rules: free for low volume
- CloudTrail (used behind the scenes): management events are free
- Lambda: 1M invocations/month free
- CloudWatch Logs: 5GB/month free

## 🛡️ Security
- IAM user has no admin rights by default — adjust policies as needed.
- You can audit events via CloudTrail for extra insight.

## ✅ Notes
- All commands are region-agnostic unless specified otherwise.
- Scripts are modular for reuse.

---

Feel free to fork, improve, and contribute.

MIT License © JP Zune
