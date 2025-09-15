#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# (수정) 모든 apt 명령어 실행 전에 잠금 해제를 먼저 기다립니다.
while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
   echo "Waiting for apt lock to be released..."
   sleep 5
done

# install nginx
sudo apt -y update
sudo apt -y install nginx

# make sure nginx is started
sudo systemctl enable --now nginx
echo "WEB-SERVER-${HOSTNAME}" | sudo tee /var/www/html/index.html

sudo apt-get install -y certbot python3-certbot-nginx
sudo certbot --nginx --non-interactive --agree-tos -m admin@itskillboost.com -d test.itskillboost.com
sudo certbot renew --dry-run