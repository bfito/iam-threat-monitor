#!/bin/bash
set -e

cat << "EOF"

       (                  )         (     
   (   )\ )      (     ( /(         )\ )  
   )\ (()/( (    )\    )\())     ( (()/(  
 (((_) /(_)))\((((_)( ((_)\      )\ /(_)) 
 )\___(_)) ((_))\ _ )\ _((_)  _ ((_|_))   
((/ __| |  | __(_)_\(_) \| | | | | | _ \  
 | (__| |__| _| / _ \ | .` | | |_| |  _/  
  \___|____|___/_/ \_\|_|\_|  \___/|_|    
                                                                                                                   
EOF
echo ""

read -p "Enter the username prefix to clean (e.g., demo-user): " PREFIX

echo "🧹 Select what you want to clean for '$PREFIX':"
echo "1) IAM User"
echo "2) EventBridge Rule"
echo "3) CloudWatch Logs"
echo "4) Lambda Function"
echo "5) IAM Role"
echo "6) Full Cleanup"
echo "0) Cancel"

read -p "Your choice: " CHOICE

case $CHOICE in
  1) ./delete_iam_user.sh "$PREFIX" ;;
  2) ./delete_eventbridge_rule.sh "$PREFIX" ;;
  3) ./delete_log_group.sh "$PREFIX" ;;
  4) ./delete_lambda.sh "$PREFIX" ;;
  5) ./delete_iam_role.sh "$PREFIX" ;;
  6)
    ./delete_iam_user.sh "$PREFIX"
    ./delete_eventbridge_rule.sh "$PREFIX"
    ./delete_log_group.sh "$PREFIX"
    ./delete_lambda.sh "$PREFIX"
    ./delete_iam_role.sh "$PREFIX"
    ;;
  0) echo "❌ Cancelled."; exit 0 ;;
  *) echo "Invalid choice."; exit 1 ;;
esac
