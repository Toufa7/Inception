#!/bin/sh

# Dependencies
apt install wget mariadb-server net-tools iputils-ping vim -y
sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)"
echo "[Success: MariaDB dependencies]"
sleep 5


# Configuring MaridDB
old="bind-address            = 127.0.0.1"
new="bind-address            = 0.0.0.0"
sed -i "s/$old/$new/g" /etc/mysql/mariadb.conf.d/50-server.cnf
echo "[Success: MariaDB Configurations]"
sleep 5

# Running mysql in background mode
/usr/bin/mysqld_safe &

sleep 10

# Creating a database called X and a user called Y with a password Y then grant him all privileges on my X database
mysql < queries.sql
sleep 3


service mariadb stop
sleep 5

/usr/bin/mysqld_safe