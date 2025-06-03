#!/bin/bash
# Creates an IAM user, assigns to a group, attaches policy, and enables MFA reminder

USERNAME=$1
GROUPNAME="SecuredGroup"

aws iam create-user --user-name $USERNAME
aws iam create-group --group-name $GROUPNAME
aws iam add-user-to-group --user-name $USERNAME --group-name $GROUPNAME
aws iam attach-group-policy --group-name $GROUPNAME --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess

echo "User $USERNAME created and added to $GROUPNAME. Don't forget to assign MFA via AWS Console."
