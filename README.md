![](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/nginx-banner.png)
## linux/arm,linux/arm64,linux/amd64 多平台支持，甲骨文ARM、华为ARM、香橙派ARM 测试可以使用
```
# tag 20210703  linux/arm,linux/arm64,linux/amd64 多平台支持
docker pull hongwenjun/nginx-php:20210703
```
### 启动 nginx-php-fpm8.2 容器

```
docker run -d -p 80:80 -p 443:443  \
    --cpus 0.8   --restart=always   \
    -v /var/www/html:/var/www/html   \
    --name  nginx-php      \
    hongwenjun/nginx-php
```

## 基于 debian:stable-slim 配置 Docker 容器  nginx-php-fpm8.2 镜像

```
# Docker 编译 Dockerfile
docker build -t nginx-php https://git.io/nginx-php

# 测试启动 nginx-php8.2-fpm 容器
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

### 使用 buildx 构建多平台 Docker 镜像
- 参考文章  https://blog.csdn.net/alex_yangchuansheng/article/details/103343697/
```
docker login

# 三个平台同时编译打包
docker buildx build -t hongwenjun/nginx-php \
--platform=linux/arm,linux/arm64,linux/amd64 . --push

```

-----

##  [Dockerfile](https://git.io/nginx-php) 使用 supervisor 启动 php-fpm  和 nginx 服务
```
FROM debian

#  安装 nginx supervisor php7.4-fpm 省略 ......

#  映射目录和端口和三个配置文件
EXPOSE 80/tcp  443/tcp
# VOLUME [ /var/www/html  /etc/nginx/conf.d  /etc/nginx/cert ]

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
                fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        }

}
```

##  FROM 多阶段镜像构建
```
FROM  hongwenjun/nginx-php  AS builder
RUN rm .dockerignore -rf

FROM scratch
COPY --from=builder .  .

CMD ["/start.sh"]

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

