AWS IAM DEMO    

# IAM Threat Monitor Demo

This project sets up a secure IAM environment in AWS with enforced password policies and login monitoring using EventBridge and Lambda. It includes scripts to automate setup and teardown for safe testing.

## 🛠 You're Writing Infrastructure as Code Without a Framework

You're doing it by hand using Bash and AWS CLI — no Terraform, CDK, or CloudFormation. That:

-    Gives you control and learning 👏
-    Adds complexity and friction 🧱
-    Means you’re also doing your own debugging, path fixing, IAM logic, and error handling


## 📦 Features

- ✅ Creates an IAM group to collect all test users in one place.
- ✅ Password policy enforcement (complexity, expiration)
- ✅ IAM user creation with temporary password
- ✅ EventBridge rule to detect non-MFA console logins
- ✅ Lambda function to log those events
- ✅ CloudWatch Logs group to store the events
- ✅ Fully scriptable setup and cleanup
- ✅ Lambda function to log those events with built-in testing simulation

## 📁 File Structure

```
iam-threat-monitor-main/
├── main_setup.sh                 # Top-level setup runner
├── policies/                    # IAM & EventBridge JSON definitions
│   ├── change_password_policy.json
│   └── eventbridge_rule_console_login.json
├── scripts/
│   ├── iam/                     # IAM logic (user, password, policy)
│   ├── lambda/                  # index.js + create_lambda.sh
│   └── eventbridge/             # Rule creation + Lambda hookup
├── util/
│   ├── cleanup/                 # delete_*.sh scripts + interactive_cleanup.sh
│   ├── zip_lambda.sh            # zips lambda/index.js
│   └── run_sanitized.sh         # redacts output
└── README.md

```
## 🔧 Tool Behavior Flow (Main Script)

When you run ./main_setup.sh testuser:x
    ✅ Creates IAM test user (testuser)
    ✅ Sets password, assigns policy
    ✅ Adds user to isolated test group
    ✅ Deploys EventBridge rule to detect console logins without MFA
    ✅ Zips index.js into lambda_function.zip
    ✅ Creates Lambda function and IAM execution role
    ✅ Links Lambda to the EventBridge rule

```
## 🧰 Tools & Techniques Used

| Category | Tools/Approach |
|----------|----------------|
| Language | Bash |
| AWS Services | IAM, Lambda, EventBridge, CloudWatch Logs |
| Security | Password policy enforcement, MFA monitoring |
| Logging | Sanitized output via run_sanitized.sh |
| Scripting Best Practices | set -e, SCRIPT_DIR, REPO_ROOT, modular scripts |
| Deployment | CLI-driven, modular, portable |

## 🚀 How to Run

1. Make sure your AWS CLI is configured and has sufficient permissions.

2. Run the setup script:

```bash
chmod +x main_setup.sh
./main_setup.sh demo-user
```

This will:
- Apply IAM password policy
- Create IAM user with tags for tracking and group for permissions.
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

##  🔐 Security Mindset & Best Practices
✅ Password policy enforcement
✅ MFA-based login monitoring
✅ Role-based access separation
✅ Logging without exposing secrets
✅ Dedicated test group isolation for IAM users
✅ Modular cleanup tooling (interactive_cleanup.sh + delete_*)
- IAM user has no admin rights by default — adjust policies as needed.
- You can audit events via CloudTrail for extra insight.

## ✅ Notes
- All commands are region-agnostic unless specified otherwise.
- Scripts are modular for reuse.
- AWS Policy Simulator: Used to safely test and validate IAM policies before applying them in production. Helps ensure least-privilege access and avoid permission misconfigurations. https://policysim.aws.amazon.com/home/index.jsp?#

## 🟡 Remaining Gaps / Tweaks to Consider
🔄 create_lamArea	Suggestion
bda.sh	✅ Now fixed to use temp file for trust policy
🔄 interactive_cleanup.sh	Show matching users before deletion (in progress)
🗃 Resource tagging	Add tags for Lambda, IAM users, groups
🔒 Least privilege	Limit policies for test group/Lambda role
📜 README.md	Add usage instructions and visual diagrams
🧪 Unit testing/mock mode	Optional: Add dry-run mode for scripts

---

Feel free to fork, improve, and contribute.

MIT License © JP Zune🛠 You're Writing Infrastructure as Code Without a Framework

