#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# (수정) 모든 apt 명령어 실행 전에 잠금 해제를 먼저 기다립니다.
while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
   echo "Waiting for apt lock to be released..."
   sleep 5
done

# 잠금이 풀린 후 패키지 목록 업데이트와 설치를 진행합니다.
sudo apt-get -y update
sudo apt-get -y install nginx

# Nginx 서비스 시작 및 활성화
sudo systemctl enable --now nginx

# 호스트 이름을 포함한 index.html 파일 생성
echo "WEB-SERVER-${HOSTNAME}" | sudo tee /var/www/html/index.html