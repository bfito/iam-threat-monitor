# AWS IAM Automation & Threat Detection (MFA + EventBridge)

## Overview
This project demonstrates how to:
- Set up secure IAM users and groups
- Enforce MFA using policy conditions
- Monitor login events via EventBridge
- Automate IAM setup using AWS CLI
- Stay entirely within AWS Free Tier

## Files
- `mfa_enforced_policy.json` – Denies all actions unless MFA is present
- `create_user.sh` – Bash script to create and assign users
- `eventbridge_rule_console_login.json` – EventBridge rule for detecting console logins without MFA

## Setup Instructions
1. Run `create_user.sh newuser`
2. Apply `mfa_enforced_policy.json` to test user or group
3. Create EventBridge rule using the event pattern in `eventbridge_rule_console_login.json`
4. Link rule to SNS topic to receive email alerts

## Outcome
Demonstrates hands-on IAM security, automation, and threat detection logic for job-readiness in Cloud Support or Security.

## Developer Notes & Learning Curve

### delete_test_user.sh #This script started as a simple AWS CLI test — but through iteration, it became a production-grade IAM user cleanup utility.

Key things I learned:
- AWS doesn't allow IAM users to be deleted unless they are fully detached from groups, policies, and access keys
- Profiles don't own IAM users — they’re just authentication wrappers
- CLI scripting helped me deeply understand IAM dependencies and errors like DeleteConflict
- Building a reusable, safe script required input validation, preview modes, and protection for critical accounts

I plan to revisit this with a Terraform-based approach next, as part of my infrastructure-as-code learning path.

=======
### 🔧 Prerequisites

- AWS CLI installed and configured with admin-level permissions
- AWS account with CloudTrail and EventBridge enabled
- Bash-compatible terminal (Linux, macOS, WSL, etc.)

---

### ✅ Recommended Quick Start (All-in-One)

```bash
chmod +x main_setup.sh
./main_setup.sh

This script automates the following:

    Creates a test IAM user

    Attaches the MFA-required policy

    Creates an EventBridge rule to detect logins without MFA

🪛 Manual Setup (Optional: Step-by-Step)

    Create user

./create_test_user.sh yourusername

Attach MFA-required policy

aws iam put-user-policy \
  --user-name yourusername \
  --policy-name EnforceMFA \
  --policy-document file://mfa_enforced_policy.json

Set up EventBridge rule

    aws events put-rule \
      --name ConsoleLoginWithoutMFA \
      --event-pattern file://eventbridge_rule_console_login.json \
      --event-bus-name default

    (Optional) Link the rule to an SNS topic to get email alerts

🧹 Cleanup

To delete the user and related resources:

./delete_test_user.sh yourusername

💡 Learning Highlights

    IAM policy logic with MFA enforcement

    AWS login monitoring with EventBridge

    Shell scripting with AWS CLI

    IAM lifecycle automation and cleanup


📘 Future Plans

    Rebuild this using Terraform for full infrastructure-as-code

    Extend with CloudWatch logs or SNS alerts

    Add support for group-based policy enforcement

📜 License
MIT

