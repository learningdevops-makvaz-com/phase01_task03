# Update and install software
apt -y update && sudo apt -y upgrade
apt -y install php-mysql mysql-server php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip nginx php7.4-fpm

# Obtain wordpress configuration file
#git clone https://github.com/devanbenz/wordpress_nginx_conf.git

# Copy wordpress config to nginx sites avail

if [ ! -f /etc/nginx/sites-available/wordpress ]
then
    cp /vagrant/wordpress /etc/nginx/sites-available/
    # Link wordpress configuration file 
    ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
fi

# If default sites enabled is linked unlink it
if [ -f /etc/nginx/sites-enabled/default ]
then
    unlink /etc/nginx/sites-enabled/default
fi

# MYSQL DB stuff 
if  ! mysql -u root -e 'use wordpress' 
then
    mysql < /vagrant/wordpress.sql
fi

# Get wordpress and unarchive 
if [ ! -d /var/www/wordpress ]
then
    wget https://wordpress.org/latest.tar.gz
    tar xvfz latest.tar.gz

    #Copy wp config stuff then copy wordpress dir to nginx root
    cp /vagrant/wp-config.php /home/vagrant/wordpress/
    mv /home/vagrant/wordpress /var/www/.

    # Cleanup 
    rm -rf /home/vagrant/latest.tar.gz
fi

if [ ! -v /usr/local/bin/wp ]
then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

    chmod +x /home/vagrant/wp-cli.phar
    mv /home/vagrant/wp-cli.phar /usr/local/bin/wp
fi

wp core install --url=192.168.50.2 --title="Game Player Magazine" --admin_user=admin --admin_password=!2three456. --admin_email=admin@test.com --path=/var/www/wordpress --allow-root
wp theme install twentysixteen --activate --path=/var/www/wordpress --allow-root

# Set ownership 
chown -R www-data:www-data /var/www/wordpress
#restart nginx
systemctl restart nginx.service
