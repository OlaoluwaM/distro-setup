#!/usr/bin/env bash

# Restores cronjobs
# Requirements: dotfiles to be present

echo "Restoring cron jobs....\c"

if ! doesFileExist "$DOTS_DIR/system/crontab-backup.bak"; then
    echo "Could not find file containing cronjobs to restore. Perhaps the path to the file ($DOTS_DIR/system/crontab-backup.bak) does not exist."
    echo "Please create and populate this file then re-run this script. Moving on..."
    return
fi

crontab "$DOTS_DIR/system/crontab-backup.bak"
echo "Cronjobs successfully restored!"
