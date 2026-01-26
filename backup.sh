#!/bin/bash

set -e

REPO_DIR="/home/aechewhy/Games/backups"

cd "$REPO_DIR" || exit 1

git add .

if ! git diff --cached --quiet; then
  git commit -m "Auto backup: $(date '+%Y-%m-%d %H:%M:%S')"
  git push
fi
