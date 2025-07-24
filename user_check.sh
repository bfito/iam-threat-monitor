#!/bin/bash
set -e

require_username() {
  if [[ -z "$1" ]]; then
    echo "❌ Error: No username provided to $(basename "$0")"
    echo "Usage: $0 <username>"
    exit 1
  fi
  USERNAME="$1"
}
