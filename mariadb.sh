#!/bin/bash

# Function to check if MariaDB is installed
is_mariadb_installed() {
    dpkg -l | grep -q mariadb-server
    return $?
}

# Update package list and upgrade packages quietly
sudo apt update -qq -y
sudo apt upgrade -qq -y

# Check if MariaDB is installed
if is_mariadb_installed; then
    if whiptail --yesno "MariaDB is already installed. Do you want to remove it?" 10 60; then
        # Remove MariaDB server
        sudo apt remove --purge mariadb-server -y
        sudo apt autoremove -y
        sudo apt clean
        
        whiptail --msgbox "MariaDB has been removed." 10 60
    else
        whiptail --msgbox "MariaDB is already installed and will not be removed." 10 60
    fi
else
    # Install MariaDB server
    sudo apt install mariadb-server -y
    
    # Secure the installation
    sudo mysql_secure_installation
    
    # Enable and start MariaDB service
    sudo systemctl enable mariadb
    sudo systemctl start mariadb
    
    # Show installation confirmation using whiptail
    whiptail --msgbox "MariaDB installation and setup complete!" 10 60
fi

# Check MariaDB status
sudo systemctl status mariadb
