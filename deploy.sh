#!/bin/bash
set -euo pipefail

HASH=$(md5 -q assets/style.css | cut -c1-8)

# Inject hash into a temp copy of index.html
TMP=$(mktemp)
sed "s|assets/style.css[^\"]*|assets/style.css?v=${HASH}|g" index.html > "$TMP"
chmod 644 "$TMP"

rsync -av --delete --exclude='.DS_Store' \
  assets \
  rv415:/home/ds/sites/codein.ca/

rsync -av "$TMP" \
  rv415:/home/ds/sites/codein.ca/index.html

rm "$TMP"

echo "Deployed with style.css?v=${HASH}"
