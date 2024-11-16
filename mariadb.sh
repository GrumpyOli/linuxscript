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

sudo curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | sudo bash -s

# Update package list and upgrade packages quietly
sudo apt update -qq -y

# Install MariaDB server
sudo apt install mariadb-server -y

echo -e "You need to run the command mysql_secure_installation to complete the MariaDB setup"

