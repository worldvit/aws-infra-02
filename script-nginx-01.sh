#!/bin/bash
# sleep until instance is ready
sleep 10
# install nginx
sudo apt -y update
sudo apt -y install nginx


# make sure nginx is started
sudo systemctl enable --now nginx
sudo echo "WEB-SERVER-01" > /var/www/html/index.html