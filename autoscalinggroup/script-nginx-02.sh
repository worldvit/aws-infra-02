#!/bin/bash
# sleep until instance is ready
sleep 10
# install nginx
sudo apt -y update
sudo apt -y install nginx

# make sure nginx is started
sudo systemctl enable --now nginx
echo "WEB-SERVER-${HOSTNAME}" | sudo tee /var/www/html/index.html

# sudo apt-get update
# sudo apt-get install -y certbot python3-certbot-nginx
# sudo certbot --nginx --non-interactive --agree-tos -m admin@itskillboost.com -d test.itskillboost.com
# sudo certbot renew --dry-run