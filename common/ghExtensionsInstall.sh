#!/usr/bin/env bash

if ! command -v gh &>/dev/null || [[ $(
  ssh -T git@github.com
  echo $?
) -gt 1 ]]; then
  echo "Either the Github CLI is yet to be setup or you are yet to connect to github via ssh"
  return
fi

echo "Installing screensaver extension"
! (gh extension list | grep 'vilmibm/gh-screensaver') &>/dev/null && gh extension install vilmibm/gh-screensaver
echo "Screensaver extension installed"
printf "\n"

echo "Installing extension that allows you to delete repos from commandline"
! (gh extension list | grep 'mislav/gh-delete-repo') &>/dev/null && gh extension install mislav/gh-delete-repo
echo "gh-delete-repo extension installed"
printf "\n"

echo "Installing extension for viewing contribution graph"
! (gh extension list | grep 'kawarimidoll/gh-graph') &>/dev/null && gh extension install kawarimidoll/gh-graph
echo "Extension for viewing contribution graph installed"
printf "\n"
