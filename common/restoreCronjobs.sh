#!/usr/bin/env bash

# Requires that dotfiles have been synced

if [[ -n "$DOTFILES" ]]; then
    echo "Restoring cron jobs...."
    crontab "$DOTFILES/system/crontab-backup.bak"
    echo -e "Restoration complete!\n"
fi

