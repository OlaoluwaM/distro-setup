#!/usr/bin/env bash

# Must be sourced in a setup.sh script of a distro because some of the variables used here
# will be defined there
# shellcheck disable=SC2154

echo "Let's get ricing!!"

# shellcheck source=../../../common/ricing/gnome/catppuccin/gtk.sh
. "$commonScriptsDir/ricing/gnome/catppuccin/gtk.sh"
echo -e "\n"

# shellcheck source=../../../common/ricing/gnome/catppuccin/cursors.sh
. "$commonScriptsDir/ricing/gnome/catppuccin/cursors.sh"
echo -e "\n"

# shellcheck source=../../../common/ricing/gnome/colloid/icons.sh
. "$commonScriptsDir/ricing/gnome/colloid/icons.sh"

echo "Ricing complete!"
echo "Althoug most of the work has been done for you, there are still a couple of things left to do such as"
echo "  - setting the gnome shell theme in gnome-tweaks"
echo "  - setting the cursor theme in gnome-tweaks"
