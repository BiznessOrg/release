#!/usr/bin/env sh

if [ "$(id -u)" -ne 0 ]; then
	echo "Must run as root!!!"
	exit 1
fi

for pkg in curl stow unzip; do
	apk add "$pkg"
done

cd $HOME

REPO="BiznessOrg/release"
CURRENT_VERSION=$(cat version.lock 2>/dev/null || echo "")
LATEST_VERSION=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | jq -r '.tag_name')

if [ -z "$CURRENT_VERSION" ] || [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
	wget "https://github.com/$REPO/releases/download/$LATEST_VERSION/$LATEST_VERSION.zip" \
		-o update.log -O "packages.zip" &&
	rm -rf packages 2>/dev/null &&
	unzip "packages.zip" &&
	rm "packages.zip" &&
	cd packages && apk add --allow-untrusted *.apk &&
  cd .. && echo "$LATEST_VERSION" > version.lock
fi
