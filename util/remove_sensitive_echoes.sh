#!/bin/bash
set -e

ROOT_DIR="${1:-.}"
echo "🔍 Scanning for sensitive echo output in: $ROOT_DIR"

# File patterns to search
find "$ROOT_DIR" -type f -name "*.sh" | while read -r FILE; do
  echo "🛠 Cleaning $FILE..."

  cp "$FILE" "$FILE.bak"  # Backup original

  # Comment out or replace risky echo lines
  sed -i \
# ⚠️ Removed:     -e '/echo.*UserId/ s/^/# ⚠️ Removed: /' \
# ⚠️ Removed:     -e '/echo.*arn:aws/ s/^/# ⚠️ Removed: /' \
# ⚠️ Removed:     -e '/echo.*Password/ s/^/# ⚠️ Removed: /' \
# ⚠️ Removed:     -e '/echo.*AccessKeyId/ s/^/# ⚠️ Removed: /' \
# ⚠️ Removed:     -e '/aws .*--output json/ s/^/# ⚠️ Removed: /' \
# ⚠️ Removed:     -e '/aws .*--query/ s/^/# ⚠️ Removed: /' \
# ⚠️ Removed raw aws output:     -e '/echo.*aws / s/^/# ⚠️ Removed raw aws output: /' \
    "$FILE"

  echo "✅ Cleaned: $FILE (original saved as $FILE.bak)"
done

echo "🏁 Done. Review files and test to confirm functionality."
