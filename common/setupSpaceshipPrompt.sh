#!/usr/bin/env bash
# https://github.com/spaceship-prompt/spaceship-prompt
# https://github.com/spaceship-prompt/spaceship-prompt/issues/351#issuecomment-360202618

if ! npm list -g spaceship-prompt &>/dev/null; then
  echo "Setting up spaceship-prompt"
  npm i -g spaceship-prompt
fi
