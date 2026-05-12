#!/usr/bin/env bash

# Setup Flathub and install certain flatpaks
# https://developer.fedoraproject.org/deployment/flatpak/flatpak-usage.html

echo "Updating installed packages..."
sudo dnf update -y
echo -e "Done!\n"

echo "Adding flathub repository if it hasn't been added already..."

if ! isProgramInstalled flatpak; then
	echo "Looks like Flathub hasn't been integrated yet :/"
	echo "Please integrate Flathub then re-run this script. Skipping..."
	return
else
	echo "Flathub has been connected to gnome-software manager"
	echo "You can now install apps listed on flathub through gnome-software manager"
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	sudo flatpak override --filesystem="$HOME/.themes"
	sudo flatpak override --filesystem="$HOME/.icons"
fi
echo -e "\n"

echo "Installing flatpaks..."
flatpakList="$SETUP_ASSETS_DIR/flatpaks.txt"

if ! doesFileExist "$flatpakList"; then
	echo "Cannot find flatpak app list at $flatpakList"
	return
fi

while IFS= read -r applicationId; do
	[[ -z "$applicationId" || "$applicationId" == \#* ]] && continue

	if flatpak list --app --columns=application | grep -Fx "$applicationId" &>/dev/null; then
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
done <"$flatpakList"

echo "Flatpaks have been installed successfully!"
