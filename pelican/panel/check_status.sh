#!/bin/bash

# Function to print messages in color
print_in_color() {
  case $1 in
    "green") echo -e "\e[32m$2\e[0m" ;;
    "red") echo -e "\e[31m$2\e[0m" ;;
  esac
}

# List of packages to verify
packages=(curl tar unzip php8.3 php8.3-gd php8.3-mysql php8.3-mbstring php8.3-bcmath php8.3-xml php8.3-curl php8.3-zip php8.3-intl php8.3-sqlite3 php8.3-fpm nginx mariadb-server mariadb-client)

# Loop through the list and check if each package is installed
for package in "${packages[@]}"; do
  if dpkg -s $package >/dev/null 2>&1; then
    printf "[\e[32mInstalled\e[0m] %s\n" "$package"
  else
    printf "[\e[31mNot Installed\e[0m] %s\n" "$package"
  fi
done
