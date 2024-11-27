#!/bin/bash

# Function to display the menu
show_menu() {
    CHOICE=$(whiptail --title "Pelican Panel Installation" \
        --menu "Choose an option:" 15 60 4 \
        "1" "Install Pelican Panel (Full Installation)" \
        "2" "Install packages" \
        "3" "Install MariaDB" \
        "4" "Configure MariaDB" \
        "5" "Install Redis" \
        "6" "Install NGINX" \
        "7" "Configure NGINX for Pelican Panel" \
        "6" "Download Pelican Panel files" \
        "7" ""
        "4" "Quit" 3>&1 1>&2 2>&3)

    case $CHOICE in
        1)
            install_pelican
            ;;
        2)
            check_requirements
            ;;
        3)
            show_log
            ;;
        4)
            echo "Exiting script."
            exit 0
            ;;
        *)
            echo "Invalid option. Exiting."
            exit 1
            ;;
    esac
}

add_repos() {
    # Add PHP repository
    sudo add-apt-repository -y ppa:ondrej/php

    # Update package list
    sudo apt update -qq
}

install_mariadb(){
    # Add MariaDB repository
    curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash

    # Setting up MariaDB
    if whiptail --title "MariaDB setup" --yesno "Do you want to proceed with the configuration?" 10 60; then
        sudo mysql_secure_installation
    fi

}

install_redis(){
    # Add Redis repository
    sudo curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
    sudo echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

    # Installing Redis
    if whiptail --title "Redis setup" --yesno "Do you want to install redis?" 10 60; then
        sudo apt install -y redis-server
        sudo systemctl enable --now redis-server
    fi

}

install_process(){
    add_repos

}

# Install required packages
sudo apt install -y tar unzip mariadb-client mariadb-server whiptail php8.3 php8.3-fpm php8.3-gd php8.3-mysql php8.3-mbstring php8.3-bcmath php8.3-xml php8.3-curl php8.3-zip php8.3-intl php8.3-sqlite3 nginx




# Create the /var/www/pelican folder
sudo mkdir -p /var/www/pelican

# Navigate to the folder
cd /var/www/pelican

# Download and extract panel.tar.gz
curl -L -s https://github.com/pelican-dev/panel/releases/latest/download/panel.tar.gz | sudo tar -xz -C /var/www/pelican

# Install Composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Run composer install
sudo composer install --quiet --no-dev --optimize-autoloader

# Giving folder permission
sudo chmod -R 755 storage/* bootstrap/cache/
sudo chown -R www-data:www-data /var/www/pelican

sudo rm /etc/nginx/sites-enabled/default

# Define NGINX configuration file path
NGINX_CONFIG="/etc/nginx/sites-available/pelican.conf"

# Check if the NGINX configuration file exists using the file_exists function
if [[ -e "/etc/nginx/sites-available/pelican.conf" ]]; then
    # If the file exists, skip creating the new config and keep the existing one
    echo -e "\nNGINX configuration file already exists. Keeping the current configuration."
else
    # If the file doesn't exist, proceed to set up the new configuration
    echo -e "\nNGINX configuration file doesn't exist. Applying new configuration..."

    # Remove the default nginx configuration
    sudo rm /etc/nginx/sites-enabled/default

    # Download the new configuration file
    curl -L https://raw.githubusercontent.com/GrumpyOli/scripts/refs/heads/main/pelican/nginx/http/pelican.conf -o /etc/nginx/sites-available/pelican.conf

    # Enable the new configuration by creating a symlink
    sudo ln -s /etc/nginx/sites-available/pelican.conf /etc/nginx/sites-enabled/

    sudo nano /etc/nginx/sites-available/pelican.conf

    # Reload NGINX to apply the new configuration
    sudo systemctl reload nginx

    echo -e "\nNGINX configuration has been successfully set up."
fi

cd /var/www/pelican

sudo php artisan p:environment:setup

show_menu