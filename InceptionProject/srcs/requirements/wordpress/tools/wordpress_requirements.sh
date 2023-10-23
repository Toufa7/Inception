#!/bin/bash
sleep 15
# Dependencies
apt install -y wget net-tools vim mariadb-client iputils-ping sudo php7.4-fpm php-mysql
sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)"
echo "[SUCCESS: Wordpress dependencies]"
sleep 5


# Installing Wordpress-CLI
cd /var/www/html/wordpress
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar && sudo mv wp-cli.phar /usr/local/bin/wp
sudo wp core download --allow-root
echo "[SUCCESS: Wordpress-CLI]"
chown -R www-data:www-data /var/www/html/wordpress
sleep 5


DIR="/run/php"
if [ ! -d "$DIR" ]; then
    mkdir -p $DIR
fi


# Wordpress Configuration Settings
wp core config --dbname=$WP_DB_NAME --dbuser=$WP_DB_USER --dbpass=$WP_DB_PASS --dbhost=$WP_DB_HOST --path=/var/www/html/wordpress --allow-root
wp core install --url=$WP_URL --title=$WP_TITLE --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASS --admin_email=$WP_EMAIL --allow-root
wp user create $WP_USER $WP_USER_EMAIL --role=author --user_pass=$WP_USER_PASSWORD --allow-root
echo -e "[SUCCESS: WORDPRESS (wp-config.php, admin, user)]"
sleep 5

# Verifying user and admin has been successfully created
wp core is-installed --allow-root
wp user list --allow-root
sleep 10

# mysql -h mariadb -u user1 -pus@r123

chown -R www-data:www-data /var/www/html/wordpress


php-fpm7.4 --nodaemonize