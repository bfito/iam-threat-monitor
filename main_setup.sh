#!/bin/bash

# === Set Profile and Username ===
PROFILE="my-secure-profile"
USERNAME="test-iam-monitor-user"

# === Start Setup ===
echo "Starting IAM Threat Monitor setup..."

# Step 1: Create Groups and Attach Policies
./create_groups_and_policies.sh "$PROFILE"

# Step 2: Create IAM User and Add to Group
./create_test_user.sh "$USERNAME" "$PROFILE"

# Step 3: Setup EventBridge Rule
./setup_eventbridge_rule.sh "$PROFILE"

# === Final Output ===
echo "Setup complete."
echo "Reminder: Enable MFA for '$USERNAME' manually via:"
echo "https://console.aws.amazon.com/iam/home#/users/$USERNAME?section=security_credentials"
