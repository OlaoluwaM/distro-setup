#!/usr/bin/env bash

if [[ -z "${DOTS+x}" ]]; then
  echo "This script requires that we have cloned and setup our dotfiles"
  echo "Please do so before attempting to run this script again."
  return
fi

echo "Restoring settings into dconf..."

echo "Restoring Deja Dup settings..."

if doesFileExist "$SYS_BAK_DIR/deja-dup-config-backup.txt"; then
  dconf load /org/gnome/deja-dup/ < "$SYS_BAK_DIR/deja-dup-config-backup.txt"
  echo "Restoration complete"
else
  echo "Deja Dup configuration file could not be found skipping"
fi
echo -e "\n"

echo "Restoring Tilix settings..."

if doesFileExist "$SYS_BAK_DIR/tilix-backup.txt"; then
  dconf load /com/gexperts/Tilix/ < "$SYS_BAK_DIR/tilix-backup.txt"
  echo "Restoration complete"
else
  echo "Tilix configuration file could not be found skipping"
fi
