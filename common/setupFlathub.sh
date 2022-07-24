#!/usr/bin/env bash

# Requires flatpak and that flathub repos are initialized

sudo dnf update -y
printf "\n"

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

if command -v flatpak &>/dev/null; then
  echo "Flathub has been connected to gnome-software manager"
  echo "You can now install apps listed on flathub through gnome-software manager"

  echo "Installing the following from Flathub"

  flatpakApplicationIds=("rest.insomnia.Insomnia" "org.telegram.desktop" "com.spotify.Client" "com.bitwarden.desktop""org.linux_hardware.hw-probe" "org.gnome.Extensions" "codes.merritt.FeelingFinder" "com.mattjakeman.ExtensionManager" "com.ticktick.TickTick" "org.gnome.Notes" "org.gnome.Chess" "com.discordapp.Discord" "im.riot.Riot")

  for applicationId in "${flatpakApplicationIds[@]}"; do
    if (flatpak list --app | grep "$applicationId") &>/dev/null; then
      echo "Seems like $applicationId has already been installed. Skipping...."
    else
      echo "Installing $applicationId..."
      flatpak install flathub "$applicationId" -y

      [[ $? -eq 0 ]] && echo "Successfully installed $applicationId"
    fi
    printf "\n"

  done

  echo "Flathub setup complete"
else
  echo "Oops, looks like flathub hasn't been integrated yet :/"
  exit 1
fi

printf "\n"
