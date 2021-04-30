![](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/nginx-banner.png)
## 基于 debian:unstable-slim 配置 Docker 容器  nginx-php-fpm7.4 镜像

```
# 下载 nginx-php7.4-fpm 项目源码
git clone https://github.com/hongwenjun/nginx-php.git

cd nginx-php

# Docker 编译 Dockerfile
docker build -t nginx-php .

# 测试启动 nginx-php7.4-fpm 容器
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

### 启动 nginx-php-fpm7.4 容器

```
docker run -d -p 80:80 -p 443:443  \
    --cpus 0.8   --restart=always   \
    -v /var/www/html:/var/www/html   \
    --name  nginx-php      \
    hongwenjun/nginx-php
```
-----

##  Dockerfile 文件  使用 supervisor 启动 php-fpm  和 nginx 服务
```
FROM debian:unstable-slim
RUN  apt update -y && \
     apt install -y --no-install-recommends --no-install-suggests nginx supervisor wget  \
     php7.4 php7.4-fpm php7.4-sqlite3 php7.4-xml php7.4-zip php7.4-pgsql php7.4-mbstring  \
     php7.4-bcmath php7.4-json php7.4-mysql php7.4-gd php7.4-cli php7.4-curl php7.4-cgi && \
     mkdir -p  /var/run/php  /run/php  && \
     wget https://raw.githubusercontent.com/hongwenjun/nginx-php/main/start.sh          && \
     wget https://raw.githubusercontent.com/hongwenjun/nginx-php/main/default            && \
     wget https://raw.githubusercontent.com/hongwenjun/nginx-php/main/supervisord.conf    && \
     mv ./default  /etc/nginx/sites-enabled/default  && \
     mv ./supervisord.conf   /etc/supervisord.conf   && \
     chmod +x  /start.sh  && \
     ln -sf /dev/stdout /var/log/nginx/access.log  && \
     ln -sf /dev/stderr /var/log/nginx/error.log   && \
     echo "<?php phpinfo(); ?>"  > /var/www/html/index.php && \
     apt remove -y wget && \     
     rm -rf /var/lib/apt/lists/*   /var/cache/apt

VOLUME [/var/www/html  /etc/nginx/sites-enabled ]
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
                fastcgi_pass unix:/run/php/php7.4-fpm.sock;
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

