#!/usr/bin/env bash

if isPackageInstalled libcurl-minimal; then
	# https://discussion.fedoraproject.org/t/command-line-updating-issues/135369
	echo "Swapping libcurl-minimal for libcurl..."
	sudo dnf swap -y libcurl-minimal libcurl
	sudo dnf update -y
	echo "libcurl-minimal has been swapped for libcurl"
else
	echo "libcurl-minimal is not installed. Skipping swap."
fi
