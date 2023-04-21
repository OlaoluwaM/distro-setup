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

aliasListFile="$DOTS/gh/alias-list.txt"
aliasList="$(cat "$aliasListFile")"

if [[ $? -ne 0 ]] || [[ -z ${aliasList+x} ]]; then
  echo "Could not find any aliases for the Github CLI"
  return 1
fi

aliasCount="$(wc -l "$aliasListFile" | awk '{ print $1} ')"

for ((i = 1; i <= aliasCount; i++)); do
  currentAlias="$(sed -n "${i}p" "$aliasListFile" | awk -F ':' '{ print $1 }')"
  correspondingAliasCommand="$(sed -n "${i}p" "$aliasListFile" | awk -F ':' '{ print $2 }')"

  gh alias set "$currentAlias" "$correspondingAliasCommand"
done
