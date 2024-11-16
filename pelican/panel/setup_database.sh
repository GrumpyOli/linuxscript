#!/bin/bash

echo -e "Setting up database for Pelican Panel"
echo -e "Default user name will be pelican"
read -p "What will be you're password for the pelican user?" DBPWD -s
read -p "What is your root password for MySQL|MariaDB?" ROOTPW -s
echo -e $DBPWD
echo -e $ROOTPW


#    sudo mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER 'pelican'@'127.0.0.1' IDENTIFIED BY '$MYSQL_PELICAN_PASSWORD';"
#    sudo mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE panel;"
#    sudo mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON panel.* TO 'pelican'@'127.0.0.1';"
#    sudo mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
