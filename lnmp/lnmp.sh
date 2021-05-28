#!/bin/bash

# Usage:  curl -L http://git.io/lnmp.sh | bash

# 建立网站和数据库目录和下载wordpress程序设置目录权限
mkdir -p  /data/www/   /data/mysql
cd  /data/www
curl https://cn.wordpress.org/latest-zh_CN.tar.gz | tar -zx
chown -R www-data:www-data  /data/www/wordpress

# 安装 docker-compose 部署工具，部署lnmp
wget  https://raw.githubusercontent.com/hongwenjun/nginx-php/main/lnmp/docker-compose.yml
apt install -y docker-compose
docker-compose up -d

# 配置 wordpress 默认密码
echo ":: 数据库名:  wordpress"
echo "::  用户名 :  root"
echo "::  密  码 :  WordPress@2021"
echo "::数据库主机: 172.17.0.1"