#!/bin/bash

# Function to check if MariaDB is installed
is_mariadb_installed() {
    dpkg -l | grep -q mariadb-server
    return $?
}

# Check if MariaDB is installed
if is_mariadb_installed; then
    echo "MariaDB is already installed. Exiting the script."
    exit 0
fi

# Update package list and upgrade packages quietly
sudo apt update -qq -y
sudo apt upgrade -qq -y

# Install MariaDB server
sudo apt install mariadb-server -y

# Secure the installation
sudo mysql_secure_installation

# Enable and start MariaDB service
sudo systemctl enable mariadb
sudo systemctl start mariadb

# Check MariaDB status
sudo systemctl status mariadb
