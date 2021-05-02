# Update and install software
sudo apt -y update && sudo apt -y upgrade
apt -y install php-mysql mysql-server php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip nginx php7.4-fpm

# Obtain wordpress configuration file
#git clone https://github.com/devanbenz/wordpress_nginx_conf.git

# Copy wordpress config to nginx sites avail
cp /vagrant/wordpress /etc/nginx/sites-available/

#rm -rf wordpress_nginx_conf

# Link wordpress configuration file 
ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
unlink /etc/nginx/sites-enabled/default

# MYSQL DB stuff 
mysql < /vagrant/wordpress.sql

# Get wordpress and unarchive 
wget https://wordpress.org/latest.tar.gz
tar xvfz latest.tar.gz

#Copy wp config stuff then copy wordpress dir to nginx root
cp /vagrant/wp-config.php /home/vagrant/wordpress/
mv /home/vagrant/wordpress /var/www/.

# Cleanup 
rm -rf /home/vagrant/latest.tar.gz



curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x /home/vagrant/wp-cli.phar
mv /home/vagrant/wp-cli.phar /usr/local/bin/wp

wp core install --url=10.10.30.22 --title="Game Player Magazine" --admin_user=admin --admin_password=!2three456. --admin_email=admin@test.com --path=/var/www/wordpress --allow-root
wp theme install twentysixteen --activate --path=/var/www/wordpress --allow-root

# Set ownership 
chown -R www-data:www-data /var/www/wordpress
#restart nginx
systemctl restart nginx.service
