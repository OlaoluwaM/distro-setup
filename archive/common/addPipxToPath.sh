#!/usr/bin/env bash

# https://github.com/pypa/pipx

echo "Adding pipx to your path..."

if isProgramInstalled pipx; then
  echo "Looks like you already have pipx installed and in your path. Moving on..."
  return
fi

pipx ensurepath
