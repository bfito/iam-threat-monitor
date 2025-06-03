# 🔐 AWS IAM + Login Monitoring Project (Free Tier Friendly)

## 🧠 Overview
This project demonstrates how to:
- Set up secure IAM users and groups
- Enforce MFA using policy conditions
- Monitor login events via EventBridge
- Automate IAM setup using AWS CLI
- Stay entirely within AWS Free Tier

## 📁 Files
- `mfa_enforced_policy.json` – Denies all actions unless MFA is present
- `create_user.sh` – Bash script to create and assign users
- `eventbridge_rule_console_login.json` – EventBridge rule for detecting console logins without MFA

## 🚀 Setup Instructions
1. Run `create_user.sh newuser`
2. Apply `mfa_enforced_policy.json` to test user or group
3. Create EventBridge rule using the event pattern in `eventbridge_rule_console_login.json`
4. Link rule to SNS topic to receive email alerts

## ✅ Outcome
Demonstrates hands-on IAM security, automation, and threat detection logic for job-readiness in Cloud Support or Security.

## 🔗 License
MIT
