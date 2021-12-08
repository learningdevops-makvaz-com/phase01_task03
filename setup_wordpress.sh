#!/bin/bash
# Please do not remove this line. This command tells bash to stop executing on first error. 
set -e

# Your code goes below ...
echo 'This script should install and setup Wordpress'

#Install nginx, mysql and php packages
sudo apt update
sudo apt upgrade -y
sudo apt install nginx -y
sudo apt install mysql-server -y
sudo apt install php7.4-cli php7.4-fpm php7.4-mysql php7.4-json php7.4-opcache php7.4-mbstring php7.4-xml php7.4-gd php7.4-curl -y

#Firewall
sudo ufw enable
sudo ufw allow 'Nginx Full'

#Create database
sudo mysql -e "CREATE DATABASE wpDB DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
sudo mysql -e "CREATE USER 'berna'@'localhost' IDENTIFIED BY 'Berna123';"
sudo mysql -e "GRANT ALL ON wpDB.* TO 'berna'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

#Wordpress install and permissions
cd /tmp
sudo wget https://wordpress.org/latest.tar.gz
tar xvf latest.tar.gz
sudo cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
sudo mkdir /var/www/html/mywordpress
sudo mv /tmp/wordpress/* /var/www/html/mywordpress
sudo chown -R www-data:www-data /var/www/html/mywordpress
sudo find /var/www/html/mywordpress -type f -exec chmod 775 {} \;
sudo find /var/www/html/mywordpress -type f -exec chmod 644 {} \;

#Create Wordpress server block
sudo -s
sudo cat > /etc/nginx/sites-available/wordpress << EOF
server {
	listen 80;
	server_name 192.168.50.2;
	root /var/www/html/mywordpress;
	index index.php index.html index.htm;
	
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


#Symbolic link
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
#Unlink default config
sudo unlink /etc/nginx/sites-enabled/default
#test syntax errors
#sudo nginx -t
#restart ngnix
#sudo systemctl restart nginx

#Configure Wp.config to connect it to the DB
cd /var/www/html/mywordpress/
sudo sed -i 's/'database_name_here'/wpDB/g' wp-config.php
sudo sed -i 's/'username_here'/berna/g' wp-config.php
sudo sed -i 's/'password_here'/Berna123/g' wp-config.php


#Install and WP-CLI config
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
path='/var/www/html/mywordpress/'
wp core install --url=192.168.50.2 --title=wpPage --admin_user=admin --admin_email=asd@hotmail.com --admin_password=\!2three456 --path=$path --allow-root
wp theme install twentynineteen --path=$path --activate --allow-root

sudo systemctl restart nginx
sudo systemctl restart mysql 

sudo apt-get install w3m