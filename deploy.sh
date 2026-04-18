#!/bin/bash
set -euo pipefail

rsync -av --delete --exclude='.DS_Store' \
  index.html \
  assets \
  xps15:/home/ds/home-server-setup/data/nginx/html/codein/
