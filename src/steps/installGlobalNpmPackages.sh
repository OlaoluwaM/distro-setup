#!/usr/bin/env bash

echo "Installing global NPM packages using pnpm..."

if ! isProgramInstalled pnpm; then
	echo "The pnpm CLI is required to install global packages from the NPM registry"
	skipStep "Please install pnpm, then re-run this script."
	return
fi

PACKAGES="$DOTS_DIR/npm/global-npm-pkgs.txt"

if ! doesFileExist "$PACKAGES"; then
	echo "Cannot find the list of NPM packages to install. The path to the file containing these packages ($PACKAGES) might not exist."
	skipStep "Please create this file, then re-run this script."
	return
fi

function isNpmPackageInstalled() {
	local PACKAGE="$1"
	pnpm -g ls --depth 0 | grep -F "$PACKAGE" &>/dev/null
}

while read -r package; do
	[[ -z "$package" || "$package" == \#* ]] && continue
	packageName=${package}

	if isNpmPackageInstalled "$packageName"; then
		alreadyDone "$packageName is installed"
		echo -e "\n"
		continue
	fi

	runOrFail "Could not install global NPM package $packageName." pnpm add -g "$packageName"
	success "$packageName installed"
	echo -e "\n"

done \
	<"$PACKAGES"

success "Global NPM package step complete"
