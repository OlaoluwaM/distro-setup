#!/usr/bin/env bash

# Directory containing RPM files
RPM_DIR="$HOME/Downloads/rpms" # Replace with your directory path

# Check if the directory exists
if [ ! -d "$RPM_DIR" ]; then
	skipStep "Directory $RPM_DIR does not exist."
	return
fi

echo "Installing local RPMs..."

rpms_to_skip=("slack" "cuda" "mailspring")
failedInstallCount=0

# Find all rpms in the RPM directory
while read -r rpm_file; do
	skip=false

	# Check each file against all substrings in the skip_patterns array
	for pattern in "${rpms_to_skip[@]}"; do
		if [[ "$rpm_file" == *"$pattern"* ]]; then
			skip=true
			break
		fi
	done

	# Install the RPM if it does not match any skip pattern
	if [ "$skip" = false ]; then
		echo "Installing $rpm_file..."
		if ! sudo dnf install "$rpm_file" -y; then
			warn "Could not install $rpm_file"
			((failedInstallCount++))
		fi
	else
		echo "Skipping $rpm_file..."
	fi
	echo -e "\n"
done < <(find "$RPM_DIR" -type f -name '*.rpm')

if [[ $failedInstallCount -gt 0 ]]; then
	failSetup "$failedInstallCount local RPM install(s) failed."
fi

success "Local RPM installation complete"
