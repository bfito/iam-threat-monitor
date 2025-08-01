#!/bin/bash
set -e

echo "📦 Zipping Lambda function..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LAMBDA_SRC="$REPO_ROOT/scripts/lambda"
ZIP_PATH="$LAMBDA_SRC/lambda_function.zip"

cd "$LAMBDA_SRC"
zip -q "$ZIP_PATH" index.js

echo "✅ Lambda function zipped: $ZIP_PATH"
