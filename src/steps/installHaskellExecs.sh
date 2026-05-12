#!/usr/bin/env bash

# Install using the command `stack install`

if ! isProgramInstalled stack; then
	echo "The stack CLI is required to install these programs"
	skipStep "Please install it using GHCup, then re-run this script."
	return
fi

echo "Installing hlint, implicit-hie, and ghc-events..."

runOrFail "Could not update the Stack package index." stack update
runOrFail "Could not install Haskell executables with Stack." stack install hlint implicit-hie ghc-events

success "hlint, implicit-hie, and ghc-events installed"
