#!/bin/bash
set -e
source "${BASH_SOURCE%/*}/user_check.sh"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$REPO_ROOT/util/divider.sh"

require_username "$1"
USERNAME="$1"
TEST_GROUP="IAMThreatMonitorTestGroup"

# Check if group exists; if not, create it
if ! aws iam get-group --group-name "$TEST_GROUP" &>/dev/null; then
  echo "📁 Creating test group: $TEST_GROUP"
  aws iam create-group --group-name "$TEST_GROUP"
else
  echo "ℹ️ Group '$TEST_GROUP' already exists. Skipping."
fi

# Check if user exists
if aws iam get-user --user-name "$USERNAME" &>/dev/null; then
  echo "ℹ️ IAM user '$USERNAME' already exists. Skipping creation."
else
  CREATE_USER_OUTPUT=$(aws iam create-user --user-name "$USERNAME")
  echo "✅ IAM user '$USERNAME' created."

  # Redact sensitive output
  echo "$CREATE_USER_OUTPUT" | "$REPO_ROOT/util/sanitize_output.sh"
fi

# Tag the user (safe to run even if user already existed)
aws iam tag-user --user-name "$USERNAME" \
  --tags Key=Purpose,Value=IAMThreatMonitorTest

# Add user to the test group
aws iam add-user-to-group \
  --user-name "$USERNAME" \
  --group-name "$TEST_GROUP"

echo "✅ User created and added to test group: $USERNAME"
