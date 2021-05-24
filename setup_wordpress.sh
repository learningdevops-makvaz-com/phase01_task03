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


# install the needed packages
sudo apt update
sudo apt-get upgrade -y
sudo apt install nginx -y
sudo apt install mysql-server -y 
sudo apt install php7.4 php7.4-fpm php7.4-mysql php7.4-curl php7.4-gd php7.4-intl php7.4-mbstring php7.4-soap php7.4-xml php7.4-xmlrpc php7.4-zip 0 -y

#configure firewall nginx
sudo ufw enable
sudo ufw allow 'Nginx HTTP'

# install and configure mysql-server
sudo mysql -e "CREATE DATABASE $Dbname DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
sudo mysql -e "CREATE USER '$Dbuser'@'localhost' IDENTIFIED BY '$Dbpass';"
sudo mysql -e "GRANT ALL ON $Dbname.* TO '$Dbuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

#configure nginx to use the PHP Processor
# Cybergamerz can be changed to any domain name you want
sudo mkdir /var/www/cybergamerz
sudo chown -R $USER:$USER /var/www/cybergamerz
cat << EOF > /etc/nginx/sites-available/cybergamerz
server {
	listen 80;
	server_name cybergamerz www.cybergamerz;
	root /var/www/cybergamerz;

	index index.html index.htm index.php;

	location / {
		try_files $uri $uri/ =404;
	}

	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/var/run/php/php-7.4-fpm.sock;
	}

	location ~ /|.ht {
		deny all;
	}
}
EOF

sudo ln -s /etc/nginx/sites-available/cybergamerz /etc/nginx/sites-enabled/
sudo unlink /etc/nginx/sites-enabled/default




