#!/usr/bin/env bash

# Directory containing RPM files
RPM_DIR="$HOME/Downloads/rpms" # Replace with your directory path

# Check if the directory exists
if [ ! -d "$RPM_DIR" ]; then
    echo "Directory $RPM_DIR does not exist."
    exit 1
fi

echo "Installing local RPMs..."

rpms_to_skip=("slack" "cuda" "mailspring")

# Find all rpms in the RPM directory
find "$RPM_DIR" -type f -name '*.rpm' | while read -r rpm_file; do
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
        sudo dnf install "$rpm_file" -y
    else
        echo "Skipping $rpm_file..."
    fi
    echo -e "\n"
done

echo "Installation complete."
