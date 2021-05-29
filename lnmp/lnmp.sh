#!/bin/bash

# Usage:  curl -L https://git.io/lnmp.sh | bash


# 数据库 root 密码设置

passwd=WordPress@2021

echo -e ":: 数据库root 默认密码: ${passwd} 现在可修改; "
read -p ":: 请输入你要的密码(按回车不修改): " -t 30 new

if [[ ! -z "${new}" ]]; then
    passwd="${new}"
fi

if [ ! -e '/var/ip_addr' ]; then
    echo -n $(curl -4 ip.sb) > /var/ip_addr
fi
serverip=$(cat /var/ip_addr)


# 建立网站和数据库目录和下载wordpress程序设置目录权限
mkdir -p  /data/www/   /data/mysql
cd  /data/www
curl https://cn.wordpress.org/latest-zh_CN.tar.gz | tar -zx
chown -R www-data:www-data  /data/www/wordpress


# 下载 lnmp docker 镜像  docker-compose.yml 部署脚本
if [ ! -e '/data/www/docker-compose.yml' ]; then
    wget https://raw.githubusercontent.com/hongwenjun/nginx-php/main/lnmp/docker-compose.yml -O /data/www/docker-compose.yml
fi

if [[ ! -z "${passwd}" ]]; then
    sed -i "s/WordPress@2021/${passwd}/g"  /data/www/docker-compose.yml
fi

# 安装 docker-compose 部署工具
if [ -e '/etc/redhat-release' ]; then
    if [ ! -e '/usr/local/bin/docker-compose' ]; then
        wget https://262235.xyz/docker-compose  -O /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
    fi
    groupadd www-data
    useradd -g www-data www-data
    chown -R www-data:www-data  /data/www/wordpress
else
    apt install -y docker-compose
fi

clear

# 部署lnmp容器  docker-compose.yml
docker-compose up -d


# 停止删除部署           #  移除 mysql 已有数据
# docker-compose down    ;  rm  /data/mysql -rf


# 配置 wordpress 默认密码
echo -e ":: 如果下载docker-compose.yml失败 网址: https://github.com/hongwenjun/nginx-php"
echo
echo -e ":: 登陆网址:  http://${serverip}/wp-admin   配置wordpress网站信息"
echo -e ":: 数据库名:  wordpress  \n::  用户名 :  root  \n::  密  码 :  ${passwd}  \n::  db主机 :  db "
echo
echo -e ":: 数据库管理:  http://${serverip}:10086  "
