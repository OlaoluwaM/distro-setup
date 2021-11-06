#!/usr/bin/env bash

# commonScriptsDir="$(dirname "$0")"

sudo dnf update -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

if command -v flatpak &>/dev/null; then
  echo "Flathub has been connected to gnome-software manager"
  echo "You can now install apps listed on flathub through gnome-software manager"

  echo "Installing the following from Flathub"

  flatpakApplicationIds=("rest.insomnia.Insomnia" "org.telegram.desktop" "com.spotify.Client" "com.bitwarden.desktop" "io.github.Figma_Linux.figma_linux" "org.linux_hardware.hw-probe" "org.gnome.Extensions")

  for applicationId in "${flatpakApplicationIds[@]}"; do
    if (flatpak list --app | grep "$applicationId") &>/dev/null; then
      echo "Seems like $applicationId has already been installed. Skipping...."
    else
      echo "Installing $applicationId..."
      flatpak install "$applicationId"
      [[ $? -eq 0 ]] && echo "Successfully installed $applicationId"
    fi
    printf "\n"

  done

  echo "Flathub setup complete"
else
  echo "Oops, looks like flathub hasn't been integrated yet :/"
fi

printf "\n"
