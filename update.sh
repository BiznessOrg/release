#!/bin/bash

REPO="BiznessOrg/release"
CURRENT_VERSION=$(cat version 2>/dev/null || echo "")
LATEST_VERSION=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | jq -r '.tag_name')

if [ -z "$CURRENT_VERSION" ] || [ "$(printf '%s\n' "$CURRENT_VERSION" "$LATEST_VERSION" | sort -V | head -n1)" = "$CURRENT_VERSION" ] && [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
   curl -L "https://github.com/$REPO/archive/refs/tags/$LATEST_VERSION.zip" -o "packages.zip"
   unzip -q "packages.zip"
   rm "packages.zip"
   echo "$LATEST_VERSION" > version
fi
