#!/usr/bin/env bash

echo "Setting up automatic updates..."
if [[ $(systemctl list-timers 'dnf-automatic-install.timer' 'dnf5-automatic.timer') =~ "0 timers" ]]; then
	sudo dnf install -y --allowerasing dnf5-plugin-automatic
	gh gist view -r '5cc6a37d1c9fc687d241a802a98c9db7' | sudo tee /etc/dnf/automatic.conf >/dev/null
	sudo systemctl enable --now dnf5-automatic.timer
	echo "Automatic updates have been set up"
else
	echo "Automatic updates have already been enabled"
fi
