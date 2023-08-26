#!/bin/bash

RED="\033[31m"
GREEN="\033[32m"
RESET="\033[0m"

# Dependencies
apt install openssl wget nginx systemctl iputils-ping curl vim -y
apt install nmap -y
sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)"
echo -e "${GREEN}[SUCCESS: NGINX dependencies]${RESET}"
sleep 5

# Certificate Configs
country="MA"
state="Benguerir"
locality="Benguerir-Marrakech"
organization="POMS Inc"
organizational_unit="1337"
common_name="www.poms.me"
email="o.toufah@mail.com"

mkdir -p /etc/nginx/ssl/

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizational_unit/CN=$common_name/emailAddress=$email"
echo -e "${GREEN}[SUCCESS: NGINX Certificate]${RESET}"
sleep 5

# Nginx 
# while true ; do cat /var/log/nginx/access.log ; sleep 10; done