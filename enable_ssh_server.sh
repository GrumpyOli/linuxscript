#!/bin/bash
# This script installs and configures OpenSSH Server on a Linux system

# Inform the user that the installation process is starting
echo "Installing OpenSSH Server .."

# Update the system package lists quietly to reduce unnecessary output
sudo apt update -q

# Install the OpenSSH Server package quietly and with confirmation
sudo apt install -y -q openssh-server

# Inform the user about modifying firewall rules
echo "Modifying firewall rules to allow OpenSSH Server"

# Allow SSH traffic through the firewall by enabling the necessary rules
sudo ufw allow ssh
