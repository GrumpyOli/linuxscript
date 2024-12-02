#!/bin/bash

# Get the current kernel version
KERNEL_VERSION=$(uname -r)

# Check if the kernel version ends with the problematic suffixes
if [[ "$KERNEL_VERSION" == *-grs-ipv6-64 || "$KERNEL_VERSION" == *-mod-std-ipv6-64 ]]; then
    echo "WARNING: Your kernel version is '$KERNEL_VERSION'."
    echo "This is a modified kernel that does not support some Docker features required for Wings to operate correctly."
    echo "Please contact your host and request a non-modified kernel."
    exit 1
else
    echo "Your kernel version is '$KERNEL_VERSION'. It appears to be a supported kernel."
fi

sudo rm -rf /var/lib/docker 2>/dev/null
sudo rm -rf /var/lib/containerd 2>/dev/null

sudo rm /etc/apt/sources.list.d/docker.list 2>/dev/null
sudo rm /etc/apt/keyrings/docker.asc 2>/dev/null


# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable --now docker

sudo mkdir -p /etc/pelican /var/run/wings

sudo curl -L -o /usr/local/bin/wings "https://github.com/pelican-dev/wings/releases/latest/download/wings_linux_$([[ "$(uname -m)" == "x86_64" ]] && echo "amd64" || echo "arm64")"

sudo chmod u+x /usr/local/bin/wings

sudo tee /etc/systemd/system/wings.service > /dev/null <<EOF
[Unit]
Description=Wings Daemon
After=docker.service
Requires=docker.service
PartOf=docker.service

[Service]
User=root
WorkingDirectory=/etc/pelican
LimitNOFILE=4096
PIDFile=/var/run/wings/daemon.pid
ExecStart=/usr/local/bin/wings
Restart=on-failure
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

sudo nano /etc/pelican/config.yml

systemctl enable --now wings