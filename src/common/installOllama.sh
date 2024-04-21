#!/usr/bin/env bash

# Install Ollama
# https://github.com/ollama/ollama/blob/main/docs/linux.md

echo "Installing Ollama..."

if isProgramInstalled ollama; then
  echo "Ollama has already been installed. Moving on..."
  return
fi

if ! isProgramInstalled curl; then
  echo "You need to install curl to install Ollama."
  echo "Please do so, then re-run this script. Exiting..."
  exit 1
fi

echo "Downloading Ollama..."
sudo curl -L https://ollama.com/download/ollama-linux-amd64 -o /usr/bin/ollama
sudo chmod +x /usr/bin/ollama
echo -e "Ollama has been installed\n"

echo "Creating user 'ollama'..."
sudo useradd -r -s /bin/false -m -d /usr/share/ollama ollama
echo -e "Done!\n"

echo "Creating ollama systemd service..."
cat <<EOF | sudo tee /etc/systemd/system/ollama.service >/dev/null
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
ExecStart=/usr/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3

[Install]
WantedBy=default.target
EOF
echo -e "Done!\n"

echo "Enabling ollama systemd service..."
sudo systemctl daemon-reload
sudo systemctl enable --now ollama
echo -e "Done!\n"

echo "Ollama has been installed!"
