#!/usr/bin/env bash

# Requires the `nativefier` npm package
# Requires my custom `nativefy.sh` script

# Create native apps with nativefier npm package

if ! (npm list -g --depth=0 | grep "nativefier") &>/dev/null; then
  echo "The nativefier package is required to run this script"
  return
fi

if [ ! -f "$HOME/nativefy.sh" ]; then
  echo "Sorry, nativefy script is also needed to run this script :P"
  return
fi

bash -c '
  declare -A nativeAppMap=([Medium]="https://medium.com" [Netflix]="https://netflix.com" [Gmail]="https://mail.google.com" [ProtonMail]="https://mail.protonmail.com/" [TickTick]="https://ticktick.com/" [Notion]="https://notion.so")

  for key in "${!nativeAppMap[@]}"; do
    value=${nativeAppMap[$key]}
    lowercaseKey=$(echo $key | tr A-Z a-z)

    if [ -f "$HOME/.local/share/applications/${lowercaseKey}.desktop" ]; then
      echo "Seems like $key has already been nativefied"
      continue
    else
      echo "Creating native application out of $key"
      zsh "$HOME/nativefy.sh" "$key" "$value"
      echo "Done! Application folder can be found at $HOME/other_apps"
    fi
    printf "\n"
  done
'

echo "Nativefication complete!"
printf "\n"
