#!/usr/bin/env bash

# Install using the command `stack install`

if ! isProgramInstalled stack; then
	echo "The stack CLI is required to install these programs"
	skipStep "Please install it using GHCup, then re-run this script."
	return
fi

echo "Installing hlint, implicit-hie, and ghc-events..."

stackPackagesToInstall=()
haskellExecs=("hlint:hlint" "implicit-hie:gen-hie" "ghc-events:ghc-events")

for haskellExec in "${haskellExecs[@]}"; do
	packageName="${haskellExec%%:*}"
	commandName="${haskellExec##*:}"

	if ! isProgramInstalled "$commandName"; then
		stackPackagesToInstall+=("$packageName")
	fi
done

if [[ ${#stackPackagesToInstall[@]} -eq 0 ]]; then
	alreadyDone "Haskell executables are installed"
	return
fi

runOrFail "Could not update the Stack package index." stack update
runOrFail "Could not install Haskell executables with Stack." stack install "${stackPackagesToInstall[@]}"

success "hlint, implicit-hie, and ghc-events installed"
