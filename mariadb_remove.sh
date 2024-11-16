#!/bin/bash

# Function to check if MariaDB is installed
is_mariadb_installed() {
    dpkg -l | grep -q mariadb-server
    return $?
}

# Check if MariaDB is installed
if is_mariadb_installed; then
    # Stop MariaDB service
    sudo systemctl stop mariadb

    # Remove MariaDB server and related packages
    sudo apt remove --purge mariadb-server mariadb-client mariadb-common -y
    
    # Remove any orphaned packages
    sudo apt autoremove -y
    
    # Clean the apt cache
    sudo apt clean

    # Remove MariaDB configuration files
    sudo rm -rf /etc/mysql /var/lib/mysql
    
    # Remove MariaDB log files
    sudo rm -rf /var/log/mysql

    echo "MariaDB and all related configuration files and logs have been removed."
else
    echo "MariaDB is not installed. Nothing to remove."
fi
