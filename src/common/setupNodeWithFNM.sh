#!/usr/bin/env bash

echo "Setting up node, pnpm, and npm with fnm"

if ! isProgramInstalled fnm; then
  echo "You need to install fnm before it can be used to install node & npm"
  echo "Please do so, then re-run this script to install Node & NPM. Exiting..."
  exit 1
fi

if isProgramInstalled node && isProgramInstalled npm && isProgramInstalled pnpm; then
  echo "fnm has already been used to install node, npm, and pnpm. Moving on..."
  return
fi

latest_node_version="$(fnm list-remote | tail -n 1)"

echo "Installing node $latest_node_version..."
fnm use "$latest_node_version" --install-if-missing --corepack-enabled
fnm default "$latest_node_version"
echo -e "Done!\n"

echo "Upgrading npm to latest version..."
npm up -g npm
echo -e "Done!\n"

echo "Upgrading pnpm..."
corepack prepare pnpm@latest --activate
sleep 2
echo -e "Done!\n"

echo "Checking versions..."
echo "node version is $(node -v)"
echo "npm version is $(npm -v)"
echo "pnpm version is $(pnpm -v)"
echo "yarn version is $(yarn -v)"
echo -e "Done\n"

echo "Checking npm installation..."
npm doctor
echo "Done!"
