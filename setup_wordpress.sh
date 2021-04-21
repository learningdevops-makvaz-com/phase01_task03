#!/bin/bash

wp_url=https://wordpress.org/latest.tar.gz

#Updating Repositories
sudo apt update

#Installing Nginx 
sudo apt install nginx -y
sudo ufw allow 'Nginx Full'

#Silent MySQL Installation - https://bit.ly/3dEty3v
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root_password'

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root_password'

sudo apt-get -y install mysql-server

mysql --user=root --password=root_password < /vagrant/script.sql

#Install php extensions for Wordpress
sudo apt install php-cli php-fpm php-mysql php-json php-opcache php-mbstring php-xml php-gd php-curl -y

#Installing Wordpress
cd /var/www/html
wget ${wp_url}
sudo tar -xzvf latest.tar.gz
rm latest.tar.gz
cd wordpress
cp /vagrant/wp-config.php .
cd ~

#Copy Nginx/Wordpress Settings
\cp /vagrant/default /etc/nginx/sites-enabled/

#Refresh nginx
sudo systemctl restart nginx
