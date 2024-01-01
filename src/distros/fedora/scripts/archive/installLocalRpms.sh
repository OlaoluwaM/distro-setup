#!/usr/bin/env bash

LOCAL_RPMS_DIR="$HOME/Downloads/rpms/"

if ! doesDirExist "$LOCAL_RPMS_DIR"; then
  echo "Local rpms directory does not exist"
  echo "You might need to restore your Deja Dup backup. Skipping installation..."
  return
fi

echo "Installing local rpms..."

# Do not quote
LOCAL_RPMS=($HOME/Downloads/rpms/*)
sudo dnf install "${LOCAL_RPMS[@]}" -y
