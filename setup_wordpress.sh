#!/bin/bash
# Please do not remove this line. This command tells bash to stop executing on first error. 
set -e

# Your code goes below ...
echo 'This script should install and setup Wordpress'

echo '---------- Update & Upgrade APT ----------'
sudo apt-get update -y
sudo apt-get upgrade -y

echo '---------- Install Nginx Package and configure Firewall ----------'
sudo apt-get install nginx -y
sudo ufw allow 'Nginx Full'

echo '---------- Install MYSQL Packages ----------'
sudo apt-get install mysql-server -y

echo '---------- Create WordPress Database & User ----------'
#debconf-set-selections lets you install mysql unattended, mysql asks for password, and we set the password
mysql_pw='YourSecurePassword123'
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${mysql_pw}"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${mysql_pw}"
#then we create the database from wpDB.sql file
sudo mysql -u root -p$mysql_pw < /vagrant/wpDB.sql

echo '---------- Install PHP Packages ----------'
sudo apt install php7.4-cli php7.4-fpm php7.4-mysql php7.4-json php7.4-opcache php7.4-mbstring php7.4-xml php7.4-gd php7.4-curl -y

echo '---------- Self-SSL Certificate ----------'
sudo openssl req -x509 -newkey rsa:2048 -days 365 -nodes \
	-subj "/C=AR/ST=BSAS/L=BSAS/O=WordPress/OU=WP/CN=192.168.50.2" \
    -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
sudo openssl dhparam -out /etc/nginx/dhparam.pem 2048

echo "------------------ Create Configuration Snippet Pointing to the SSL Key and Certificate ------------------"
sudo cp /vagrant/self-signed.conf /etc/nginx/snippets/
sudo cp /vagrant/ssl-params.conf /etc/nginx/snippets/

echo "------------------ WordPress Nginx Directory ------------------"
WP_directory='/var/www/wordpress'
if [ ! -d $WP_directory ]; then
    sudo mkdir ${WP_directory}
fi

echo "------------------ Nginx WordpressSite File Configuration && Symbolic link ------------------"
sudo cp /vagrant/WPNginxConfig.conf /etc/nginx/sites-available/wordpress
sudo ln -sf /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
sudo unlink /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx

echo "------------------ WordPress Download & Extract ------------------"
cd /tmp
wget https://wordpress.org/latest.tar.gz
sudo tar xvf latest.tar.gz

echo "------------------ WordPress Privileges Setup && Wordpress PHP Configuration ------------------"
sudo cp -a /tmp/wordpress/* ${WP_directory}
sudo chown -R www-data:www-data ${WP_directory}
sudo cp /vagrant/wp-config.php ${WP_directory}/wp-config.php

echo "------------------  WordPress CLI Installation ------------------"
#curl -O, command that lets you download a file and flag -O saves the file with the original name
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

echo "------------------  WordPress User && Wordpress Theme ------------------"
cd ${WP_directory}
wp core install --url="192.168.50.2" --title="WordPress Setup" --admin_user=admin --admin_email=admin123@admin.com --admin_password="!2three456." --allow-root
wp theme install "twentynineteen" --activate --allow-root

