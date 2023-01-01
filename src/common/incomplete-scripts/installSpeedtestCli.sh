#!/usr/bin/env bash

echo "Installing speedtest cli..."
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.rpm.sh | sudo bash
sudo dnf install speedtest
