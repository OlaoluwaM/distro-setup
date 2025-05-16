#!/usr/bin/env bash

# Install using the command `stack install`

if ! isProgramInstalled stack; then
  echo "The stack CLI is required to install these programs"
  echo "Please install it (using GHCup) then re-run this script. Exiting..."
  return
fi

echo "Installing hlint, implicit-hie, and ghc-events..."

stack update
stack install hlint implicit-hie ghc-events

echo "Successfully installed hlint and implicit-hie"
