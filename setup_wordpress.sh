#!/bin/bash

# -- Updates packages --------------------------------------
echo '################## LEMP Stack Installation ####################'
cd ~
echo "------------------ Updating APT ------------------"
echo
sudo apt -y update && sudo apt -y upgrade

echo "------------------ Installing Nginx ------------------"
sudo apt -y install nginx

echo "------------------ Configuring Firewall ------------------"
sudo ufw enable
sudo ufw allow 'Nginx HTTP'

echo "------------------ Installing MYSQL ------------------"
sudo apt -y install mysql-server
sudo mysql_secure_installation

echo "------------------ Installing PHP ------------------"
sudo apt -y install php-fpm php-mysql

echo "------------------ Configuring Nginx ------------------"
sudo mkdir /var/www/wordpress
sudo chown -R $USER:$USER /var/www/wordpress
read -p "Enter the public IP address, please (192.168.X.X): " ip_address

echo "
server {
    listen 80;
    server_name $ip_address;
    root /var/www/wordpress;

    index index.html index.htm index.php;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }

}" | sudo tee /etc/nginx/sites-available/wordpress

echo "------------------ Creating Soft Link ------------------"
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/

echo "------------------ Testing Nginx ------------------"
sudo nginx -t

echo "------------------ Restarting Nginx ------------------"
sudo systemctl reload nginx

echo "------------------ Creating Nginx Index ------------------"
echo "
<html>
  <head>
    <title>Rojin's Website</title>
  </head>
  <body>
    <h1>Hello Rojin!</h1>
  </body>
</html>" | sudo tee /var/www/wordpress/index.html

echo "You Can Test The Index Page At ${ip_address}"

echo "------------------ Creating SSL Certificate ------------------"
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
sudo openssl dhparam -out /etc/nginx/dhparam.pem 2048

echo "------------------ Creating Configuration Snippet ------------------"
sudo echo "
ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;" | sudo tee /etc/nginx/snippets/self-signed.conf

echo "------------------ Creating ssl-params.conf ------------------"
mv /vagrant/ssl-params.conf /etc/nginx/snippets/

echo "------------------ Adjusting Nginx To SSL ------------------"
sudo cp /etc/nginx/sites-available/wordpress /etc/nginx/sites-available/wordpress.bak

echo "
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    include snippets/self-signed.conf;
    include snippets/ssl-params.conf;

    server_name $ip_address;

    root /var/www/wordpress/html;
    index index.html index.htm index.nginx-debian.html;

}" | sudo tee /etc/nginx/sites-available/wordpress

echo "

server {
    listen 80;
    listen [::]:80;

    server_name $ip_address;

    return 301 https://\$server_name\$request_uri;
}" | sudo tee /etc/nginx/sites-available/wordpress

echo "------------------ Adjusting Firewall ------------------"
sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'

echo "------------------ Testing Nginx ------------------"
sudo nginx -t

echo "------------------ Restarting Nginx ------------------"
sudo systemctl restart nginx

echo "------------------ Creating WordPress Database ------------------"
read -p "Enter Your MYSQL Password: " mysql_password

sudo mysql -u root -p$mysql_password << EOF
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* to wordpressuser@'localhost';
FLUSH PRIVILEGES;
EOF

echo "The Default Password Set For The 'WordPress' Database is 'password'. You Can Change It Later."

echo "------------------ Installing PHP Extentions ------------------"
sudo apt update
sudo apt -y install php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
sudo systemctl restart php7.4-fpm

echo "------------------ Nginx Configuration ------------------"
cp /vagrant/nginx_conf /etc/nginx/sites-available/wordpress

echo "------------------ Testing Nginx ------------------"
sudo nginx -t

echo "------------------ Restarting Nginx ------------------"
sudo systemctl reload nginx

echo "------------------ Downloading WordPress ------------------"
cd /tmp
curl -LO https://wordpress.org/latest.tar.gz

echo "------------------ Extracting WordPress ------------------"
tar xzvf latest.tar.gz
sudo cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
sudo cp -a /tmp/wordpress/. /var/www/wordpress

echo "------------------ Setting Up Privileges ------------------"
sudo chown -R www-data:www-data /var/www/wordpress

echo "------------------ Configuring WordPress ------------------"
sudo cp /home/$USER/wp-config.php /var/www/wordpress/wp-config.php

echo "------------------ Installing WordPress CLI ------------------"
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
php wp-cli.phar --info
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
wp cli version

cd /var/www/wordpress
echo "------------------ Creating WordPress User ------------------"
wp core install --url="192.168.8.191" --title="WordPress Setup" --admin_user=admin --admin_email=admin@test.com --admin_password="!2three456." --allow-root

echo "------------------ Activating WordPress Theme ------------------"
wp theme install "twentynineteen" --activate --allow-root

sudo chown -R www-data:www-data /var/www/wordpress
