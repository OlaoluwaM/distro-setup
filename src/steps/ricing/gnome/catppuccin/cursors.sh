#!/usr/bin/env bash

# https://github.com/catppuccin/cursors

echo "Installing Catppuccin Cursors..."

cursors_dir="$HOME/.icons"
cursor_version="1.0.1"

runOrFail "Could not create cursor theme directory $cursors_dir." mkdir -p "$cursors_dir"

if ! isProgramInstalled curl || ! isProgramInstalled unzip; then
	skipStep "curl and unzip are required to install Catppuccin cursors."
	return
fi

EXTRACTION_TARGETS=("catppuccin-mocha-dark-cursors" "catppuccin-mocha-lavender-cursors")

for unzipTarget in "${EXTRACTION_TARGETS[@]}"; do
	if doesDirExist "$cursors_dir/$unzipTarget"; then
		alreadyDone "$unzipTarget cursor theme is installed"
		echo -e "\n"
		continue
	fi

	echo "Downloading and unzipping ${unzipTarget} cursor files..."
	runOrFail "Could not download ${unzipTarget} cursor archive." curl -LOsS "https://github.com/catppuccin/cursors/releases/download/v${cursor_version}/${unzipTarget}.zip"
	runOrFail "Could not unzip ${unzipTarget} into $cursors_dir." unzip "${unzipTarget}.zip" -d "$cursors_dir"
	removePath "${unzipTarget}.zip"
	success "$unzipTarget cursor theme installed"
	echo -e "\n"
done

success "Catppuccin cursor files are present"
echo -e "\n"

echo "Setting Cursor theme..."
runOrFail "Could not set GNOME cursor theme." gsettings set org.gnome.desktop.interface cursor-theme "catppuccin-mocha-dark-cursors"
success "Cursor theme set"
