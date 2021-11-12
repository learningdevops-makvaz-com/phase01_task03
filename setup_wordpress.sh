#!/bin/bash -xe

# Variables

DBName='wordpress_db' 
DBUsername='wordpress_user'
DBPassword='myverycoolwordpresspassword'
WordpressUser='admin'
WordpressPassword='!2three456' 
Path='/var/www/html/wordpress/mysite'
sudo apt update

# Install Assets

sudo apt install nginx php7.4 php7.4-fpm php7.4-mysql php7.4-json php7.4-opcache php7.4-mbstring php7.4-xml php7.4-gd php7.4-curl php7.4-cli mariadb-server ufw -y

# Start MariaDB & Create Database

sudo service mariadb start

cat > /tmp/db.setup <<EOF
use mysql;
CREATE DATABASE $DBName;
GRANT ALL ON $DBName.* TO '$DBUsername'@'localhost' IDENTIFIED BY '$DBPassword' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

sudo mysql -u root < /tmp/db.setup
sudo rm /tmp/db.setup

# Configure NGINX

sudo touch wordpress.conf /etc/nginx/sites-available
sudo cat >/etc/nginx/sites-available/wordpress.conf <<EOF
server {
	listen 80;
	root $path;
	index index.php index.html;
	server_name 10.0.2.15;
	
	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	location / {
		try_files \$uri \$uri/ =404;
	}

	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/run/php/php7.4-fpm.sock;
	}
	
	location ~ /\.ht {
		deny all;
	}
	 location = /favicon.ico {
                log_not_found off;
                access_log off;
	}

	 location = /robots.txt {
	        allow all;
	        log_not_found off;
	        access_log off;
	}

	location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                expires max;
                log_not_found off;
	}	
}
EOF

sudo ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled

# Download & Configure WordPress

sudo mkdir -p /var/www/html/wordpress/mysite
cd $path
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -zxvf latest.tar.gz 
sudo cp -r wordpress/* .
sudo rm -rf /var/www/html/wordpress/mysite/wordpress
sudo rm latest.tar.gz
sudo mv wp-config-sample.php wp-config.php
sudo chown -R www-data:www-data *
sudo chmod -R 755 *

# Connect Database to WordPress

sudo sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php
sudo sed -i "s/'username_here'/'$DBUsername'/g" wp-config.php
sudo sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php

# Install WP-CLI to set up login info & theme

wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
wp core install --url=10.0.2.15 --title=Wordpresstest --admin_user=admin --admin_email=admin@admin.admin --admin_password=\!2three456 --path=$path --allow-root
wp theme install twentynineteen --path=$path --activate --allow-root


# Restart NGINX & Setup UFW

sudo service nginx reload
sudo ufw enable
sudo ufw allow http



