#!/usr/bin/env bash

sudo dnf update -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# "$(
#   command -v flatpak &>/dev/null
#   echo $?
# )" -eq 0

if [ "$(isInstalled "command -v flatpak")" ]; then
  echo "Flathub has been connected to gnome-software manager"
  echo "You can now install apps listed on flathub through gnome-software manager"

  echo "Installing the following from Flathub"

  flatpakApplicationIds=("rest.insomnia.Insomnia" "org.telegram.desktop" "com.spotify.Client" "com.bitwarden.desktop" "io.github.Figma_Linux.figma_linux" "org.linux_hardware.hw-probe" "org.gnome.Extensions")

  for applicationId in "${flatpakApplicationIds[@]}"; do
    echo "Installing $applicationId..."
    flatpak install "$applicationId"

    [ "$(
      flatpak list --app | grep $applicationId
      echo $?
    )" -eq 0 ] && echo "Successfully installed $applicationId"
  done
  echo "Flathub setup complete"
else
  echo "Oops, looks like flathub hasn't been integrated yet :/"
fi
