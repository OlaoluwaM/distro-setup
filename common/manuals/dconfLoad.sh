#!/usr/bin/env bash

echo "This script needs to be run manually"
echo "You will also need to have the appropriate themes, icons, wallpapers, and fonts available"

if [ ! -f "$HOME/ola-full-dconf-settings.ini" ]; then
  echo "Dconf file for restoration not present"
  exit 0
fi

pathPrefix="/org/gnome"

specificPaths=("settings-daemon/plugins/media-keys" "settings-daemon/plugins/power" "settings-daemon/plugins/color" "nautilus" "desktop/wm" "desktop/sound" "terminal" "shell" "shell/world-clocks" "shell/overrides" "shell/keybindings" "desktop/peripherals/mouse" "desktop/notifications" "desktop/interface" "desktop/background" "gedit")

for path in "${specificPaths[@]}"; do
  echo "Restoring settings for $path"
  dconf load "$pathPrefix/$path" <"$HOME/ola-full-dconf-settings.ini"
  echo "Restoration complete"
done

echo "Restoration complete! You'll need to reboot to see the changes though -\(- -)/-"
