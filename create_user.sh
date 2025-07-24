#!/bin/bash
set -e
source "${BASH_SOURCE%/*}/user_check.sh"
require_username "$1"

CREATE_USER_OUTPUT=$(aws iam create-user --user-name "$USERNAME")

CREATE_USER_OUTPUT=$(aws iam create-user --user-name "$USERNAME")
echo "$CREATE_USER_OUTPUT" | ./sanitize_output.sh

