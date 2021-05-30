#!/bin/bash

echo 'This script should install and setup Wordpress'


# Variables needed for configurations these can be edited to anything you want
Dbname="wordpress"
Dbuser="wpuser"
Dbpass="Devops101"
Wppass="!2three456."

###############
# nginx, mysql, WordPress.
# WordPress should have already configured with theme twentynineteen and with created user admin with password !2three456..
#####################

# install packages
sudo apt update
sudo apt-get upgrade -y
sudo apt install nginx -y
sudo apt install mysql-server -y 
sudo apt install php7.4 php7.4-fpm php7.4-mysql php7.4-curl php7.4-gd php7.4-intl php7.4-mbstring php7.4-soap php7.4-xml php7.4-xmlrpc php7.4-zip -y


#configure firewall nginx
sudo ufw enable
sudo ufw allow 'Nginx HTTP'

# install and configure mysql-server
sudo mysql -e "CREATE DATABASE $Dbname DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
sudo mysql -e "CREATE USER '$Dbuser'@'localhost' IDENTIFIED BY '$Dbpass';"
sudo mysql -e "GRANT ALL ON $Dbname.* TO '$Dbuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Permissions configurations for wordpress
cd /tmp
sudo wget https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
sudo cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
sudo mkdir -p /home/www/wordpress/
sudo cp -a /tmp/wordpress/. /home/www/wordpress/
sudo chown -R www-data:www-data /home/www/wordpress/
sudo find /home/www/wordpress/ -type f -exec chmod 775 {} \;
sudo find /home/www/wordpress/ -type f -exec chmod 644 {} \;

# Create wordpress Virtual Host
cat << EOF > /etc/nginx/sites-available/wordpress
server {
	listen 80;
	server_name 10.0.2.15;

	root /home/www/wordpress/;

	index index.html index.htm index.php;

	location / {
		try_files \$uri \$uri/ index.php\$is_args\$args;
	}

	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
	}

	location ~ /\.ht {
		deny all;
	}
}
EOF

# Unlink default nginx vhost to wordpress vhost
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
sudo unlink /etc/nginx/sites-enabled/default

# Edit the wordpress config file
cd /home/www/wordpress/
sudo sed -i "s/'database_name_here'/'$Dbname'/g" wp-config.php
sudo sed -i "s/'username_here'/'$Dbuser'/g" wp-config.php
sudo sed -i "s/'password_here'/'$Dbpass'/g" wp-config.php

sudo systemctl restart nginx


#install and configure WP-CLI
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
cd /home/www/wordpress/
sudo -u www-data -- wp core install --url="192.168.50.2"  --title="Cybergamerz" --admin_user="admin" --admin_password="$Wppass" --admin_email="test@test.nl"
sudo -u www-data -- wp theme install twentynineteen
sudo -u www-data -- wp theme activate twentynineteen





