![](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/nginx-banner.png)
## 基于 debian:stable-slim 配置 Docker 容器  nginx-php-fpm7.3 镜像

```
# 下载 nginx-php7.3-fpm 项目源码
git clone https://github.com/hongwenjun/nginx-php.git

cd nginx-php

# Docker 编译 Dockerfile
docker build -t nginx-php .

# 测试启动 nginx-php7.3-fpm 容器
docker run -d -p 8888:80 --name  nginx-php  nginx-php

# 进入容器
docker exec -it  nginx-php bash

```


###  https://hub.docker.com/ 登陆、建立公共容器 ，先构造容器，再推送到远程
```
docker login
Username:  hongwenjun    Password: ******
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.

vim Dockerfile

docker build -t hongwenjun/nginx-php .

docker push hongwenjun/nginx-php

```

### 启动 nginx-php-fpm7.3 容器

```
docker run -d -p 80:80 -p 443:443  \
    --cpus 0.8   --restart=always   \
    -v /var/www/html:/var/www/html   \
    --name  nginx-php      \
    hongwenjun/nginx-php
```
-----

##  [Dockerfile](https://raw.githubusercontent.com/hongwenjun/nginx-php/main/Dockerfile) 使用 supervisor 启动 php-fpm  和 nginx 服务
```
FROM debian:unstable-slim

#  安装 nginx supervisor php7.3-fpm 省略 ......

#  映射目录和端口和三个配置文件
VOLUME [/var/www/html  /etc/nginx/conf.d  /etc/nginx/cert]
EXPOSE 80/tcp  443/tcp

# COPY ./default             /etc/nginx/sites-enabled/default
# COPY ./supervisord.conf    /etc/supervisord.conf
# COPY ./start.sh            /start.sh

CMD ["/start.sh"]

```

-----

##  default 是 debian nginx 默认配置修改成启用  php-fpm
```
#  /etc/nginx/sites-enabled/default
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        # listen 443 ssl default_server;
        # listen [::]:443 ssl default_server;

        root /var/www/html;
        index index.html index.php index.nginx-debian.html;
        server_name _;

        location / {
                try_files $uri $uri/ =404;
        }

        # pass PHP scripts to FastCGI server
        location ~ .*\.php(\/.*)*$ {
                include snippets/fastcgi-php.conf;
        #       # With php-fpm (or other unix sockets):
                fastcgi_pass unix:/run/php/php7.3-fpm.sock;
        }

}
```

##  推荐 [linuxserver/nginx](https://hub.docker.com/r/linuxserver/nginx) 也支持php和更多插件

### docker-compose (recommended)

```
---
version: "2.1"
services:
  nginx:
    image: ghcr.io/linuxserver/nginx
    container_name: nginx
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - </path/to/appdata/config>:/config
    ports:
      - 80:80
      - 443:443
    restart: unless-stopped

```

### docker cli
```
docker run -d \
  --name=nginx \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -p 80:80 \
  -p 443:443 \
  -v </path/to/appdata/config>:/config \
  --restart unless-stopped \
  ghcr.io/linuxserver/nginx
```

