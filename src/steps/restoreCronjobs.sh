#!/usr/bin/env bash

# Restores cronjobs
# Requirements: dotfiles to be present

echo "Restoring cron jobs...."

if ! doesFileExist "$DOTS_DIR/system/crontab-backup.bak"; then
	echo "Could not find file containing cronjobs to restore. Perhaps the path to the file ($DOTS_DIR/system/crontab-backup.bak) does not exist."
	skipStep "Please create and populate this file, then re-run this script."
	return
fi

runOrFail "Could not restore cron jobs from $DOTS_DIR/system/crontab-backup.bak." crontab "$DOTS_DIR/system/crontab-backup.bak"
success "Cron jobs restored"
