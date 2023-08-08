#!/bin/bash
apt install wget -y
apt install -y nginx
apt -y install systemctl
apt install -y iputils-ping
apt install -y curl
apt install -y vim

country="MA"
state="Benguerir"
locality="Benguerir-Marrakech"
organization="POMS Inc"
organizational_unit="1337"
common_name="www.poms.me"
email="o.toufah@hotmail.com"

mkdir /etc/nginx/ssl/

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizational_unit/CN=$common_name/emailAddress=$email"

# cat /var/log/nginx/access.log