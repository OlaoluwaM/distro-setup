#!/usr/bin/env bash

echo "Installing Colloid icon theme..."

icons_dir="$HOME/.icons"

icon_name="Colloid-Dark"
path_to_icon="$icons_dir/$icon_name"

if doesDirExist "$path_to_icon"; then
	if ! isProgramInstalled gsettings; then
		alreadyDone "Colloid icon theme is installed"
		skipStep "gsettings is required to select the GNOME icon theme."
	elif [[ "$(gsettings get org.gnome.desktop.interface icon-theme)" == "'$icon_name'" ]]; then
		alreadyDone "Colloid icon theme is installed and selected"
	else
		alreadyDone "Colloid icon theme is installed"
		runOrFail "Could not set GNOME icon theme." gsettings set org.gnome.desktop.interface icon-theme "$icon_name"
	fi
	return
fi

if ! isProgramInstalled gh; then
	skipStep "To run the Colloid icon setup script, please install the GitHub CLI."
	return
fi

if [[ -z ${DEV+x} ]]; then
	echo "This script will require the use of some shell functions defined in our dotfiles"
	echo "https://github.com/OlaoluwaM/dotfiles/blob/master/shell/.shell-env#L278"
	skipStep "DEV is not set."
	return
fi

# https://github.com/vinceliuice/Colloid-icon-theme

echo "Cloning repo for Colloid icon theme..."

cloneDir="$(mktemp -d)"
if [[ -z "$cloneDir" ]]; then
	failSetup "Could not create a temporary directory for the Colloid icon theme repository."
fi

runOrFail "Could not clone the Colloid icon theme repository." gh repo clone vinceliuice/Colloid-icon-theme "$cloneDir"
previousWorkingDirectory="$(pwd)"

echo "Installing icons..."
cd "$cloneDir" || failSetup "Could not enter $cloneDir."
runOrFail "Could not install Colloid icons." ./install.sh -d "$icons_dir" -s default -t default
success "Colloid icons installed"
echo -e "\n"

cd "$previousWorkingDirectory" || failSetup "Could not return to $previousWorkingDirectory."

echo "Setting icon theme..."
if ! isProgramInstalled gsettings; then
	skipStep "gsettings is required to select the GNOME icon theme."
elif [[ "$(gsettings get org.gnome.desktop.interface icon-theme)" == "'$icon_name'" ]]; then
	alreadyDone "Icon theme is set"
else
	runOrFail "Could not set GNOME icon theme." gsettings set org.gnome.desktop.interface icon-theme "$icon_name"
	success "Icon theme set"
fi
echo -e "\n"

echo "Removing artifacts..."
removePath "$cloneDir"
success "Colloid install artifacts removed"
