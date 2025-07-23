# AWS IAM Automation & Threat Detection (MFA + EventBridge)

## 🔍 Overview
This project demonstrates how to:

🔹 Set up secure IAM users and groups  
🔹 Enforce MFA using policy conditions  
🔹 Monitor login events via EventBridge  
🔹 Automate IAM setup using AWS CLI  
🔹 Stay entirely within AWS Free Tier  

---

## 📁 Files

🔹 `mfa_enforced_policy.json` – Denies all actions unless MFA is present  
🔹 `create_user.sh` – Bash script to create and assign users  
🔹 `eventbridge_rule_console_login.json` – EventBridge rule for detecting console logins without MFA  
🔹 `main_setup.sh` – Automates full IAM + policy + alert setup  
🔹 `delete_test_user.sh` – Safely removes IAM user and associated policies  

---

## 🧰 Setup Instructions

### 🔧 Prerequisites

🔹 AWS CLI installed and configured with admin-level permissions  
🔹 AWS account with CloudTrail and EventBridge enabled  
🔹 Bash-compatible terminal (Linux, macOS, WSL, etc.)  

---

### ✅ Recommended Quick Start (All-in-One)

```bash
chmod +x main_setup.sh
./main_setup.sh

This script automates the following:

🔹 Creates a test IAM user
🔹 Attaches the MFA-required policy
🔹 Creates an EventBridge rule to detect logins without MFA
🪛 Manual Setup (Optional: Step-by-Step)

🔹 Create user

./create_test_user.sh yourusername
 🔹 Ensure test user has iam:ChangePassword permission for full login demo
 🔹 Attach MFA-required policy

aws iam put-user-policy \
  --user-name yourusername \
  --policy-name EnforceMFA \
  --policy-document file://mfa_enforced_policy.json

🔹 Set up EventBridge rule

aws events put-rule \
  --name ConsoleLoginWithoutMFA \
  --event-pattern file://eventbridge_rule_console_login.json \
  --event-bus-name default

🔹 (Optional) Link the rule to an SNS topic to get email alerts
🧹 Cleanup

To delete the user and related resources:

./delete_test_user.sh yourusername

💡 Learning Highlights

🔹 IAM policy logic with MFA enforcement
🔹 AWS login monitoring with EventBridge
🔹 Shell scripting with AWS CLI
🔹 IAM lifecycle automation and cleanup
🔹 Studied the differences between IAM policy types via CLI:    
    🔹 aws iam put-user-policy → Inline policy (user-only)
    🔹 aws iam create-policy → Reusable customer-managed policy
    🔹 aws iam attach-user-policy → Attaches a managed policy to a user
    🔹 aws iam list-policies --scope AWS → Lists AWS-managed (read-only) policies
    🔹 --permissions-boundary → Sets permission limits using a managed policy

📘 Future Plans

🔹 Rebuild this using Terraform for full infrastructure-as-code
🔹 Extend with CloudWatch logs or SNS alerts
🔹 Add support for group-based policy enforcement
📜 License

MIT
