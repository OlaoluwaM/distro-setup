#!/usr/bin/env bash

if isPackageInstalled libcurl-minimal; then
	# https://discussion.fedoraproject.org/t/command-line-updating-issues/135369
	echo "Swapping libcurl-minimal for libcurl..."
	runOrFail "Could not swap libcurl-minimal for libcurl." sudo dnf swap -y libcurl-minimal libcurl
	runOrFail "Could not update packages after swapping libcurl." sudo dnf update -y
	success "libcurl-minimal swapped for libcurl"
else
	skipStep "libcurl-minimal is not installed."
fi
