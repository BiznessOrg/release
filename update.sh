#!/usr/bin/env sh

REPO="BiznessOrg/release"
CURRENT_VERSION=$(cat version.lock 2>/dev/null || echo "")
LATEST_VERSION=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | jq -r '.tag_name')

for pkg in curl jq stow unzip; do
   if ! command -v "$pkg" &> /dev/null; then
      sudo apk add "$pkg"
   fi
done

cd $HOME

if [ -z "$CURRENT_VERSION" ] || [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
   wget "https://github.com/$REPO/releases/download/$LATEST_VERSION/$LATEST_VERSION.zip" \
      -o update.log -O "packages.zip" &&
      rm -rf packages 2>/dev/null &&
      unzip "packages.zip" &&
      rm "packages.zip" &&
      echo "$LATEST_VERSION" > version.lock
fi

cd packages && stow *
