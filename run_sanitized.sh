#!/bin/bash
./main_setup.sh "$1" | sed -E \
  -e 's/("UserId": ")[^"]+/\1REDACTED/' \
  -e 's/("Arn": ")[^"]+/\1REDACTED/' \
  -e 's/::[0-9]+:/::ACCOUNT-ID:/'

