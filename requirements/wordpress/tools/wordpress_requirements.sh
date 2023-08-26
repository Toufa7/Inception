#!/bin/bash

# Dependencies
apt install -y wget net-tools vim mariadb-client iputils-ping sudo php7.4-fpm php-mysql
sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)"
echo "[SUCCESS: Wordpress dependencies]"
sleep 5


# Installing Wordpress-CLI
cd /var/www/html/wordpress
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar && sudo mv wp-cli.phar /usr/local/bin/wp
sudo mkdir Build && sudo wp core download --allow-root
echo "[SUCCESS: Wordpress-CLI]"
sleep 5


# DIR="/run/php"
# if [ ! -d "$DIR" ]; then
#     mkdir -p $DIR
# fi

# service php7.4-fpm start


# # Wordpress Configuration Settings
wp core config --dbname=$WP_DB_NAME --dbuser=$WP_DB_USER --dbpass=$WP_DB_PASS --dbhost=$WP_DB_HOST --path=/var/www/html/wordpress --allow-root
wp core install --url=$WP_URL --title=$WP_TITLE --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASS --admin_email=$WP_EMAIL --allow-root
wp user create $WP_USER $WP_USER_EMAIL --role=author --user_pass=$WP_USER_PASSWORD --allow-root
echo -e "${GREEN}[SUCCESS: WORDPRESS (wp-config.php, admin, user)]${RESET}"
sleep 5

# service php7.4-fpm stop

# Verifying user and admin has been successfully created
# wp core is-installed --allow-root
# wp user list --allow-root
# sleep 5

# mysql -h mariadb -u user1 -pus@r123

php-fpm7.4 --nodaemonize