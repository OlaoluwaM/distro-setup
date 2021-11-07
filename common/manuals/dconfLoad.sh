#!/usr/bin/env bash

if [ ! -f "$HOME/ola-full-dconf-settings.dconf" ]; then
  echo "Dconf file for restoration not present"
  exit 0
fi

dconf load -f / "$HOME/ola-full-dconf-settings.dconf"
echo "Done"
