#!/bin/bash
set -e
echo '################## LEMP Stack Installation ####################'
echo "------------------ Updating APT ------------------"
sudo apt -y update && sudo apt -y upgrade

echo "------------------ Installing Nginx ------------------"
sudo apt -y install nginx

echo "------------------ Configuring Firewall ------------------"
sudo ufw enable
sudo ufw allow 'Nginx Full'

echo "------------------ Installing MYSQL ------------------"
sudo apt -y install mysql-server

echo "------------------ Creating WordPress Database ------------------"
mysql_password=QpWo#2LuQ
debconf-set-selections <<< "mysql-server mysql-server/root_password password $mysql_password"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $mysql_password"

sudo mysql -u root -p$mysql_password << EOF
CREATE DATABASE IF NOT EXISTS wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* to wordpressuser@'localhost';
FLUSH PRIVILEGES;
EOF

echo "The Default Password Set For The 'WordPress' Database is 'password'. You Can Change It Later."

echo "------------------ Installing PHP ------------------"
sudo apt -y install php-fpm php-mysql

#echo "------------------ Configuring SSL Certificate ------------------"
sudo mv /vagrant/nginx-selfsigned.crt /etc/ssl/certs/
sudo mv /vagrant/nginx-selfsigned.key /etc/ssl/private/
sudo mv /vagrant/dhparam.pem /etc/nginx/

echo "------------------ Creating Configuration Snippet ------------------"
cp /vagrant/self-signed.conf /etc/nginx/snippets/

echo "------------------ Creating ssl-params.conf ------------------"
cp /vagrant/ssl-params.conf /etc/nginx/snippets/

echo "------------------ Installing PHP Extentions ------------------"
sudo apt update
sudo apt -y install php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
sudo systemctl restart php7.4-fpm

echo "------------------ Configuring Nginx ------------------"
sudo mkdir /var/www/wordpress
sudo chown -R www-data:www-data /var/www/wordpress

echo "------------------ Nginx Configuration ------------------"
cp /vagrant/nginx_conf /etc/nginx/sites-available/wordpress

echo "------------------ Creating Nginx Index ------------------"
cp /vagrant/index.html /var/www/wordpress/index.html
echo "You Can Test The Index Page At 192.168.50.2"

echo "------------------ Creating Soft Link ------------------"
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/

echo "------------------ Testing Nginx ------------------"
sudo nginx -t

echo "------------------ Restarting Nginx ------------------"
sudo systemctl restart nginx

echo "------------------ Downloading WordPress ------------------"
cd /tmp
FILE=wordpress-5.7.1.tar.gz
if [[ ! -f "$FILE" ]]; then
    curl -LO https://wordpress.org/wordpress-5.7.1.tar.gz
fi

echo "------------------ Extracting WordPress ------------------"
tar xzvf wordpress-5.7.1.tar.gz
sudo cp -a /tmp/wordpress/. /var/www/wordpress

echo "------------------ Setting Up Privileges ------------------"
sudo chown -R www-data:www-data /var/www/wordpress

echo "------------------ Configuring WordPress ------------------"
cp /vagrant/wp-config.php /var/www/wordpress/wp-config.php

echo "------------------ Installing WordPress CLI ------------------"
WP_CLI=wp-cli.phar
if [[ ! -f "$WP_CLI" ]]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
fi
php wp-cli.phar --info
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
wp cli version

cd /var/www/wordpress
echo "------------------ Creating WordPress User ------------------"
wp core install --url="192.168.50.2" --title="WordPress Setup" --admin_user=admin --admin_email=admin@test.com --admin_password="!2three456." --allow-root

echo "------------------ Activating WordPress Theme ------------------"
wp theme install "twentynineteen" --activate --allow-root
