#!/bin/bash
set -euo pipefail

HASH=$(md5 -q assets/style.css | cut -c1-8)

# Inject hash into a temp copy of index.html
TMP=$(mktemp)
sed "s|assets/style.css[^\"]*|assets/style.css?v=${HASH}|g" index.html > "$TMP"

rsync -av --delete --exclude='.DS_Store' \
  assets \
  xps15:/home/ds/home-server-setup/data/nginx/html/codein/

rsync -av "$TMP" \
  xps15:/home/ds/home-server-setup/data/nginx/html/codein/index.html

rm "$TMP"

echo "Deployed with style.css?v=${HASH}"
