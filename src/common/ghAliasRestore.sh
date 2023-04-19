#!/usr/bin/env bash

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

aliasList="$(cat $DOTS/gh/alias-list.txt)"

if [[ $? -ne 0 ]] || [[ -z ${aliasList+x} ]]; then
  echo "Could not find any aliases for the Github CLI"
  return 1
fi

aliases=($($aliasList | awk -F ':' '{ print $1 }'))
commands=($($aliasList | awk -F ':' '{ print $2 }'))

for ind in "${!aliases[@]}"; do
  associatedCmd="${commands[$ind]}"
  associatedAlias="${aliases[$ind]}"

  gh alias set "$associatedAlias" "$associatedCmd"
done
