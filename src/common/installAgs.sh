#!/usr/bin/env bash

# The script works to clone ags, build, and install it
# Requirements: Active Github SSH connection & Git

# This will also require node to be install along with npm
# It should also only be run AFTER symlinking our dots
# https://github.com/Aylur/ags/wiki/installation

if isProgramInstalled ags; then
  echo "ags has already been installed. Skipping..."
  return 0
fi

if ! isProgramInstalled git || ! isProgramInstalled npm || ! isProgramInstalled meson; then
  echo "Seems like one of the dependencies for this scriipt (git, npm, meson) has not been installed. You'll need it find out which and install it before you can continue this script"
  echo "Please install the required deps and set up git before re-running this script. Exiting..."
  exit 1
fi

labsPath="$HOME/Desktop/labs"

previousWorkingDirectory="$(pwd)"

echo "Cloning ags from GitHub..."
git clone --recursive https://github.com/Aylur/ags.git "$labsPath/ags-repo"
echo "Done"

echo "Building and installing..."
cd "$DEV/ags-repo" || exit
npm install
meson setup build
meson install -C build
sleep 0.5s

cd "$previousWorkingDirectory" || exit
echo -e "Done\n"

echo "ags installed!"
