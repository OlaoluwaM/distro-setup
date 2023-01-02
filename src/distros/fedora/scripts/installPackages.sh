#!/usr/bin/env bash

# shellcheck disable=SC2154

# kernel-devel is for OpenRazer. There is an issue on fedora that warrants its installation
# The g++ package is for this issue: https://github.com/nvim-treesitter/nvim-treesitter/issues/626
# The g++ package is also needed to compile the difftastic rust crate
echo "Installing system packages..."

while IFS= read -r package; do
  LINUX_PACKAGES+=("$package")
done <"$commonScriptsDir/assets/packages.txt"

# So installations can happen in parallel
sudo dnf install -y "${LINUX_PACKAGES[@]}"
echo "System packages installed!"
