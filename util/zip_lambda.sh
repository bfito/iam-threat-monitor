### scripts/lambda/zip_lambda.sh
#!/bin/bash
set -e

ZIP_NAME="lambda_function.zip"
echo "📦 Zipping Lambda function..."
cd "$(dirname "$0")"
zip -r "$ZIP_NAME" index.js
cd -
echo "✅ Lambda zipped as $ZIP_NAME"

