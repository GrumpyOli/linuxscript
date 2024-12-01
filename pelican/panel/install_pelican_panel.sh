#!/bin/bash

YELLOW="\033[0;33m" # Yellow color
RED="\033[0;31m" # Red color
GREEN="\033[0;32m" # Green color
BLUE="\033[0;34m" # Blue color
NC="\033[0m" # No color


# Define a function to display [ OK ] in green with a custom message
display_ok() {
  # Output the message with color
  echo -e "[${GREEN}OK${NC}] $1"
}

# Define a function to display [ SKIP ] in yellow with a custom message
display_skip() {
  # Output the message with color
  echo -e "[${YELLOW}SKIP${NC}] $1"
}

# Define a function to display [ FAIL ] in red with a custom message
display_fail() {
  # Output the message with color
  echo -e "[${RED}FAIL${NC}] $1"
}

# Define a function to display [ INFO ] in blue with a custom message
display_info() {
  # Output the message with color
  echo -e "[${BLUE}INFO${NC}] ${BLUE} $1 ${NC}"
}

# Check requirements
check_requirements(){

    # Define color codes
    GREEN="\033[0;32m"
    RED="\033[0;31m"
    NC="\033[0m" # No color

    # List of packages to check
    packages=(
    tar
    unzip
    php8.3
    php8.3-fpm
    php8.3-gd
    php8.3-mysql
    php8.3-mbstring
    php8.3-bcmath
    php8.3-xml
    php8.3-curl
    php8.3-zip
    php8.3-intl
    php8.3-sqlite3
    nginx
    )

    echo "Checking installed packages:"

    # Loop through each package and check if installed
    for package in "${packages[@]}"; do
    if dpkg -l "$package" &>/dev/null; then
        echo -e "[${GREEN}OK${NC}] $package"
    else
        echo -e "[${RED}FAIL${NC}] $package"
    fi
    done

    # Pause for user input
    echo "If you see a missing packages, install the required package using the correct menu options"
    read -n 1 -s -r -p "Press any key to continue..."
    echo

    show_menu

}

# Function to display the menu
show_menu() {
    CHOICE=$(whiptail --title "Pelican Panel Installation" \
        --menu "Choose an option:" 15 60 5 \
        "1" "Install Pelican Panel (Full Installation)" \
        "2" "Check requirements" \
        "3" "Custom installation" \
        "4" "Nginx Options" \
        "5" "Exit"  3>&1 1>&2 2>&3)

    case $CHOICE in
        1)
            full_install_process
            ;;
        2)
            check_requirements
            ;;
        3)
            show_log
            ;;
        4)
            configure_nginx
            ;;
        5)
            echo "Exiting script."
            exit 0
            ;;
        *)
            echo "Invalid option. Exiting."
            exit 1
            ;;
    esac
}

install_dependencies() {
    # Add PHP repository
    sudo add-apt-repository -y ppa:ondrej/php

    # Update package list
    sudo apt update -qq

    # Install required packages
    sudo apt install -y -qq tar unzip php8.3 php8.3-fpm php8.3-gd php8.3-mysql php8.3-mbstring php8.3-bcmath php8.3-xml php8.3-curl php8.3-zip php8.3-intl php8.3-sqlite3 nginx

    display_ok "PHP Repository added"
    display_ok "Packages installed"
}

install_mariadb(){
    # Add MariaDB repository
    curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
    display_ok "MariaDB installed"

    # Setting up MariaDB
    if whiptail --title "MariaDB setup" --yesno "Do you want to proceed with the configuration?" 10 60; then
        sudo mysql_secure_installation
        display_ok "MariaDB configured"
    fi

}

ask_redis(){
    # Use whiptail to ask a Yes/No question
    if whiptail --title "Redis Installation" --yesno "Do you want to install redis?" 8 50; then
        install_redis
    fi
}

install_redis(){

    # Check if Redis repository key exists
    if [ -f /usr/share/keyrings/redis-archive-keyring.gpg ]; then
        display_ok "Redis repository key already exists."
    else
        # Add Redis GPG key if it doesn't exist
        display_ok "Adding Redis GPG key..."
        curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
    fi

    # Check if Redis repository already exists
    if grep -q "https://packages.redis.io/deb" /etc/apt/sources.list.d/redis.list; then
        display_skip "Redis repository already added."
    else
        # Add Redis APT repository if not already added
        display_ok "Adding Redis repository..."
        echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list > /dev/null
    fi

    # Update apt sources to pick up the new repository
    sudo apt update -qq

    # Install Redis server
    sudo apt install -y redis-server
    display_ok "Redis installed"

    # Enable and start the Redis server
    sudo systemctl enable --now redis-server
    display_ok "Redis server enabled"

}

downlaod_nginx_configuration_file(){
    # Define local variables
    local file="$1"

    # Removing olg file configuration
    rm /etc/nginx/sites-available/pelican.conf 2>/dev/null
    rm /etc/nginx/sites-enabled/pelican.conf 2>/dev/null
    display_ok "Old configuration file remove"

    # Downloading the file
    display_info "Downloading the file..."
    sudo curl -fsSL -o /etc/nginx/sites-available/pelican.conf $file

    # Check if the download was successful
    if [[ $? -eq 0 ]]; then
        display_ok "File downloaded and placed in /etc/nginx/sites-available/"
    else
        display_fail "Failed to download the file. Please check the URL or your network connection."
        exit 1
    fi

    # Set permissions for the file
    chmod 644 /etc/nginx/sites-available/pelican.conf
    display_ok "Permissions set for the file."

    # Create a symbolic link to enable the site
    if [[ -d /etc/nginx/sites-enabled ]]; then
        ln -s /etc/nginx/sites-available/pelican.conf /etc/nginx/sites-enabled/
        display_ok "Symbolic link created in /etc/nginx/sites-enabled/"
    fi

    # Pause for user input
    display_info "File editor will open to configure the nginx website. You need to change the <domain> settings"
    read -n 1 -s -r -p "Press any key to continue..."
    echo

    sudo nano /etc/nginx/sites-available/pelican.conf

    # Reload NGINX to apply the new configuration
    sudo systemctl restart  nginx

}

configure_nginx(){

    CHOICE=$(whiptail --title "NGINX Setup" \
            --menu "Choose an option:" 15 60 5 \
            "1" "Delete Nginx default config file" \
            "2" "Download config file http with no reverse proxy" \
            "3" "Download config file http with reverse proxy" \
            "4" "Open config file" \
            "5" "Back to main menu"  3>&1 1>&2 2>&3)

    case $CHOICE in
        1)
            # Remove the default Nginx site configuration by deleting the symbolic link in the 'sites-enabled' directory
            sudo rm /etc/nginx/sites-enabled/default

            # Display a success message indicating that the default site configuration has been removed
            display_ok "Default site configuration removed"

            # Send the user back to the menu
            configure_nginx
            ;;
        2)
            # Download the Nginx configuration file from the specified URL and save it locally
            downlaod_nginx_configuration_file "https://raw.githubusercontent.com/GrumpyOli/linuxscript/refs/heads/main/pelican/panel/template/nginx_http.conf"
            
            # Send the user back to the menu
            configure_nginx
            ;;
        3)
            # Download the Nginx configuration file from the specified URL and save it locally
            downlaod_nginx_configuration_file "https://raw.githubusercontent.com/GrumpyOli/linuxscript/refs/heads/main/pelican/panel/template/nginx_http_reverse_proxy.conf"

            # Send the user back to the menu
            configure_nginx
            ;;
        4)
            # Open the Nginx configuration file for Pelican in the nano text editor (with sudo privileges)
            sudo nano /etc/nginx/sites-available/pelican.conf

            # Reload the Nginx service to apply any changes made to the configuration
            sudo systemctl reload nginx
            
            # Send the user back to the menu
            configure_nginx
            ;;
        5) 
            show_menu
            ;;
        *)
            echo "Invalid option. Exiting."
            exit 1
            ;;
    esac

}

install_pelican_panel(){
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

}

full_install_process(){
    
    # First install dependencies
    install_dependencies

    # Ask for redis installation
    ask_redis

    # Ask for Nginx Configuration 
    CHOICE=$(whiptail --title "NGINX Setup" \
            --menu "Choose an option:" 15 60 3 \
            "1" "Download config file http with no reverse proxy" \
            "2" "Download config file http with reverse proxy" \
            "3" "Skip this step"  3>&1 1>&2 2>&3)

    case $CHOICE in
        1)
            # Remove the default Nginx site configuration by deleting the symbolic link in the 'sites-enabled' directory
            sudo rm /etc/nginx/sites-enabled/default

            # Display a success message indicating that the default site configuration has been removed
            display_ok "Default site configuration removed"

            # Download the Nginx configuration file from the specified URL and save it locally
            downlaod_nginx_configuration_file "https://raw.githubusercontent.com/GrumpyOli/linuxscript/refs/heads/main/pelican/panel/template/nginx_http.conf"
            ;;
        2)
            # Remove the default Nginx site configuration by deleting the symbolic link in the 'sites-enabled' directory
            sudo rm /etc/nginx/sites-enabled/default

            # Display a success message indicating that the default site configuration has been removed
            display_ok "Default site configuration removed"

            # Download the Nginx configuration file from the specified URL and save it locally
            downlaod_nginx_configuration_file "https://raw.githubusercontent.com/GrumpyOli/linuxscript/refs/heads/main/pelican/panel/template/nginx_http_reverse_proxy.conf"
            ;;
        3)
            ;;
        *)
            ;;
    esac

    pelican_env_setup

    # Pause for user input
    display_ok "Everything is done"
    display_info "To continue, the web installer is located at <domain>/installer or <ip>/installer"
    read -n 1 -s -r -p "Press any key to continue..."
    echo
}

pelican_env_setup(){

# Create the directory '/var/www/pelican' if it doesn't already exist
mkdir -p /var/www/pelican
display_ok "Creating directory.."

# Change directory to the Pelican project root
cd /var/www/pelican

display_info "Downloading file.."

# Download and extract the latest version of the Pelican Panel from GitHub
# The output is piped directly into 'tar' to extract the contents into the current directory
curl -sSL https://github.com/pelican-dev/panel/releases/latest/download/panel.tar.gz | sudo tar -xzf - > /dev/null 2>&1

display_ok "Files downloaded"
display_info "Download and install Composer"

# Download and install Composer, a PHP dependency manager
# The installer script is fetched and then executed with PHP. It installs Composer in '/usr/local/bin' with the filename 'composer'
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer > /dev/null 2>&1

display_ok "Composer installed"
display_info "Installing project dependencies.."

# Run Composer to install project dependencies (excluding dev dependencies) and optimize the autoloader
sudo composer install --no-dev --optimize-autoloader > /dev/null 2>&1

display_ok "Dependencies installed"

# Run the Artisan command to set up the environment for the application
sudo php artisan p:environment:setup

# Set appropriate permissions for the 'storage' and 'bootstrap/cache' directories (recursively)
# 755 gives read and execute permissions to everyone, and write permissions to the owner
chmod -R 755 storage/* bootstrap/cache/

# Change ownership of the 'storage' and 'bootstrap/cache' directories to the 'www-data' user and group (commonly used for web servers)
chown -R www-data:www-data /var/www/pelican

}

show_menu