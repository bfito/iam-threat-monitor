#!/bin/bash
set -e
source "${BASH_SOURCE%/*}/user_check.sh"

require_username "$1"
USERNAME="$1"
TEST_GROUP="IAMThreatMonitorTestGroup"

# Check if group exists; if not, create it
if ! aws iam get-group --group-name "$TEST_GROUP" &>/dev/null; then
  echo "📁 Creating test group: $TEST_GROUP"
  aws iam create-group --group-name "$TEST_GROUP"
fi

# Create the user
aws iam create-user --user-name "$USERNAME"

# Optional: tag the user
aws iam tag-user --user-name "$USERNAME" \
  --tags Key=Purpose,Value=IAMThreatMonitorTest

# Add user to the test group
aws iam add-user-to-group \
  --user-name "$USERNAME" \
  --group-name "$TEST_GROUP"

echo "✅ User created and added to test group: $USERNAME"
