#!/usr/bin/env bash

# Restores cronjobs
# Requirements: dotfiles have been synced

if isDirEmpty "$HOME/Desktop/olaolu_dev/dotfiles"; then
  echo "You will need to clone the dotfiles repository from Github before your dotfiles can be symlinked. Skipping..."
  return
fi

# If $DOTFILES variable is unset, skip this script because dotfiles have not been symlinked yet
if [[ -v "${DOTFILESS+x}" ]]; then
  echo "You'll need to symlink your dotfiles before running this script. Skipping..."
  return
fi

if [[ -n "$DOTFILES" ]]; then
    echo "Restoring cron jobs...."
    crontab "$DOTFILES/system/crontab-backup.bak"
    echo -e "Restoration complete!\n"
fi
