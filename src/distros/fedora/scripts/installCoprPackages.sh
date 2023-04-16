#!/usr/bin/env bash

echo "Installing packages from Fedora COPR..."

echo "Installing betterdiscordctl to setup betterdiscord..."
if ! isProgramInstalled betterdiscordctl; then
  sudo dnf copr enable observeroftime/betterdiscordctl -y
  sudo dnf install betterdiscordctl -y
  echo "betterdiscordctl has been installed!"
  echo "You will need to login to discord before betterdiscord can act on it. Refer to the manual instructions"
else
  echo "betterdiscordctl has already been installed"
fi
echo -e "\n"

echo "Installing scrcpy..."
if ! isProgramInstalled scrcpy; then
  sudo dnf copr enable zeno/scrcpy -y
  sudo dnf install scrcpy -y
  echo "scrcpy has been installed!"
else
  echo "scrcpy has already been installed"
fi
