#!/usr/bin/env bash

echo "Installing global NPM packages using pnpm..."

if ! isProgramInstalled pnpm; then
	echo "The pnpm CLI is required to install global packages from the NPM registry"
	echo "Please install it then re-run this script."
	return
fi

PACKAGES="$DOTS_DIR/npm/global-npm-pkgs.txt"

if ! doesFileExist "$PACKAGES"; then
	echo "Cannot find the list of NPM packages to install. The path to the file containing these packages ($PACKAGES) might not exist."
	echo "Please create this file then re-run this script."
	return
fi

function isNpmPackageInstalled() {
	local PACKAGE="$1"
	pnpm -g ls --depth 0 | grep -F "$PACKAGE" &>/dev/null
}

while read -r package; do
	packageName=${package}

	if isNpmPackageInstalled "$packageName"; then
		echo -e "Seems like $packageName has already been installed. Moving to the next one...\n"
		continue
	fi

	pnpm add -g "$packageName"
	echo -e "$packageName has been installed\n"

done \
	<"$PACKAGES"

echo "Installations complete"
