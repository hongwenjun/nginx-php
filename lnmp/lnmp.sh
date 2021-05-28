#!/bin/bash

# Usage:  curl -L http://git.io/lnmp.sh | bash

# ������վ�����ݿ�Ŀ¼������wordpress��������Ŀ¼Ȩ��
mkdir -p  /data/www/   /data/mysql
cd  /data/www
curl https://cn.wordpress.org/latest-zh_CN.tar.gz | tar -zx
chown -R www-data:www-data  /data/www/wordpress

# ��װ docker-compose ���𹤾ߣ�����lnmp
wget  https://raw.githubusercontent.com/hongwenjun/nginx-php/main/lnmp/docker-compose.yml
apt install -y docker-compose
docker-compose up -d

# ���� wordpress Ĭ������
echo ":: ���ݿ���:  wordpress"
echo "::  �û��� :  root"
echo "::  ��  �� :  WordPress@2021"
echo "::���ݿ�����: 172.17.0.1"