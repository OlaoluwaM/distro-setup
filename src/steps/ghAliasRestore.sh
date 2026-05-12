#!/usr/bin/env bash

# https://cli.github.com/manual/gh_alias_import

# shellcheck disable=SC2181
# shellcheck disable=SC2207

if ! isProgramInstalled gh; then
	echo "This script requires that the Github CLI be installed"
	skipStep "Please install it, then try again."
	return
fi

dotfilesDir="${DOTS:-$DOTS_DIR}"
aliasFile="$dotfilesDir/gh/aliases.yml"

if ! doesDirExist "$dotfilesDir"; then
	echo "This script requires that we have cloned and setup our dotfiles"
	skipStep "Please do so before attempting to run this script again."
	return
fi

if ! doesFileExist "$aliasFile"; then
	echo "Cannot find GitHub CLI alias file at $aliasFile"
	return
fi

echo "Importing gh aliases..."
runOrFail "Could not import GitHub CLI aliases from $aliasFile." gh alias import --clobber "$aliasFile"
success "GitHub CLI aliases imported"
