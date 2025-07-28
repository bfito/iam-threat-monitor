#!/bin/bash
set -e

RULE_NAME="ConsoleLoginWithoutMFA"
EVENT_PATTERN_FILE="eventbridge_rule_console_login.json"
LOG_GROUP_NAME="/aws/events/NonMFAConsoleLogins"

# Create EventBridge rule if it doesn't exist
./create_eventbridge-rule.sh

# Create CloudWatch log group if it doesn't exist
./create_log_group.sh

# Attach CloudWatch Logs as a target
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
./attach_rule_target_logs.sh
