# #!/bin/bash
# # sleep until instance is ready
# sleep 10
# # install nginx
# sudo apt -y update
# sudo apt -y install nginx


# # make sure nginx is started
# sudo systemctl enable --now nginx
# sudo echo "WEB-SERVER-02" > /var/www/html/index.html

#!/bin/bash
sleep 10
sudo apt -y update
sudo apt -y install nginx
sudo systemctl enable --now nginx

# AWS EC2 메타데이터 서비스에서 인스턴스 ID를 가져와서 index.html에 쓰기
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
echo "<h1>WebServer powered by Auto Scaling Group</h1><h2>Instance ID: $INSTANCE_ID</h2>" > /var/www/html/index.html