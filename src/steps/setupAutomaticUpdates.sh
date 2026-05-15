#!/usr/bin/env bash

echo "Setting up automatic updates..."

if ! isProgramInstalled gh; then
	skipStep "GitHub CLI is required to restore the automatic updates config."
	return
fi

# DNF installs are intentionally rerun; they are idempotent and keep reruns simple.
runOrFail "Could not install dnf5-plugin-automatic." sudo dnf install -y --allowerasing dnf5-plugin-automatic
success "dnf5-plugin-automatic installed"

echo "Restoring DNF automatic updates config..."
if ! gh gist view -r '5cc6a37d1c9fc687d241a802a98c9db7' | sudo tee /etc/dnf/automatic.conf >/dev/null; then
	failSetup "Could not restore /etc/dnf/automatic.conf."
fi
success "DNF automatic updates config restored"

if systemctl is-enabled --quiet dnf5-automatic.timer && systemctl is-active --quiet dnf5-automatic.timer; then
	alreadyDone "dnf5-automatic.timer is enabled and running"
else
	runOrFail "Could not enable and start dnf5-automatic.timer." sudo systemctl enable --now dnf5-automatic.timer
	success "dnf5-automatic.timer enabled and running"
fi
