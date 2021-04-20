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

#Installing Wordpress
cd /var/www/html
wget ${wp_url}
sudo tar -xzvf latest.tar.gz
cat /vagrant/script.sql
