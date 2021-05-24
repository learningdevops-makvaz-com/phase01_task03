#!/bin/bash

echo 'This script should install and setup Wordpress'


# Variables needed for configurations

Dbname ='wordpress'
Dbuser ='wpuser'
Dbpass ='Techgrounds101'



###############
# nginx, mysql, WordPress.
# WordPress should have already configured with theme twentynineteen and with created user admin with password !2three456..
#####################


# update the virtual machine and turn on the firewall
sudo apt update
sudo apt-get upgrade -y
sudo ufw enable
sudo install nginx -y
sudo apt install mysql-server -y 
Sudo apt install php7.4 7.4-fpm php7.4 7.4-mysql php7.4-curl php7.4-gd php7.4-intl php7.4-mbstring php7.4-soap php7.4-xml php7.4-xmlrpc php7.4-zip

#configure firewall nginx
sudo ufw allow 'Nginx HTTP'

# install and configure mysql-server
sudo mysql -e "CREATE DATABASE $Dbname DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
sudo mysql -e "CREATE USER '$Dbuser'@'localhost' IDENTIFIED BY '$Dbpass';"
sudo mysql -e "GRANT ALL ON $Dbname.* TO '$Dbuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"




