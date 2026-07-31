#!/usr/bin/env bash
# Build the frontend and publish it to ojasprabhune.github.io/lifefolders.
# Run this from anywhere after editing anything in frontend/.
set -euo pipefail

LIFE_DIR="/Users/ojasprabhune/Documents/personal/life"
DOTFOLDERS_DIR="/Users/ojasprabhune/Documents/personal/dotfolders"
API_URL="https://lifefolders-api.onrender.com"

echo "==> building frontend"
cd "$LIFE_DIR/frontend"
VITE_API_URL="$API_URL" npm run build

echo "==> copying build into dotfolders/lifefolders"
rm -rf "$DOTFOLDERS_DIR/lifefolders"
mkdir -p "$DOTFOLDERS_DIR/lifefolders"
cp -r dist/. "$DOTFOLDERS_DIR/lifefolders/"

cd "$DOTFOLDERS_DIR"
git add lifefolders

if git diff --cached --quiet; then
  echo "==> no changes, nothing to publish"
  exit 0
fi

git commit -m "update lifefolders build"
git push origin main

echo "==> done: https://ojasprabhune.github.io/lifefolders/"
