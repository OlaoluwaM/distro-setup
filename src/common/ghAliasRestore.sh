#!/usr/bin/env bash

# https://cli.github.com/manual/gh_alias_import

# shellcheck disable=SC2181
# shellcheck disable=SC2207

if ! isProgramInstalled gh; then
  echo "This script requires that the Github CLI be installed"
  echo "Please install it then try again."
  return
fi

if [[ -z "${DOTS+x}" ]]; then
  echo "This script requires that we have cloned and setup our dotfiles"
  echo "Please do so before attempting to run this script again."
  return
fi

echo "Importing gh aliases..."
gh alias import "$DOTS/gh/aliases.yml"
