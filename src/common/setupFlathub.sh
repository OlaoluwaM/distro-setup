#!/usr/bin/env bash

# Setup Flathub and install certain flatpaks

echo "Updating installed packages..."
sudo dnf update -y
echo -e "Done!\n"

echo "Adding flathub repository if it hasn't been added already..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

if ! isProgramInstalled flatpak; then
  echo "Looks like Flathub hasn't been integrated yet :/"
  echo "Please integrate Flathub then re-run this script. Skipping..."
  return
else
  echo "Flathub has been connected to gnome-software manager"
  echo "You can now install apps listed on flathub through gnome-software manager"
fi
echo -e "\n"

echo "Installing flatpaks..."
flatpakApplicationIds=("rest.insomnia.Insomnia" "com.spotify.Client" "com.bitwarden.desktop" "org.linux_hardware.hw-probe" "org.gnome.Extensions" "org.gnome.Chess" "com.discordapp.Discord" "im.riot.Riot" "md.obsidian.Obsidian" "com.github.micahflee.torbrowser-launcher" "com.ticktick.TickTick")

for applicationId in "${flatpakApplicationIds[@]}"; do
  if (flatpak list --app | grep "$applicationId") &>/dev/null; then
    echo "Seems like $applicationId has already been installed. Moving to the next one...."
  else
    flatpak install flathub "$applicationId" -y

    # shellcheck disable=SC2181
    if [[ $? -eq 0 ]]; then
      echo "Successfully installed $applicationId"
    else
      echo "Failed to install $applicationId"
    fi
  fi

  echo -e "\n"
done

echo "Flatpaks have been installed successfully!"
