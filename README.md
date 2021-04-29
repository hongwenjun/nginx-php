## 基于官方 debian 配置 Docker 容器  nginx-php-fpm7.3 镜像

```
# 下载 nginx-php-fpm7.3 项目源码
git clone https://github.com/hongwenjun/nginx-php.git

cd nginx-php

# Docker 编译 Dockerfile
docker build -t nginx-php .

# 测试启动 nginx-php-fpm7.3 容器
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
- 需要先建立映射目录，如果错误，需建立目录重启容器
```
# 建立映射目录
mkdir -p  /var/www/html
mkdir -p  /var/log/nginx

docker run -d -p 80:80 -p 443:443  \
    --cpus 0.8   --restart=always   \
    -v /var/www/html:/var/www/html   \
    -v /var/log:/var/log  \
    --name  nginx-php      \
    hongwenjun/nginx-php
```
-----

##  Dockerfile 文件  使用 supervisor 启动 php-fpm  和 nginx 服务
```
FROM debian
RUN  apt update -y && \
     apt install -y --no-install-recommends  nginx php-fpm supervisor && \
     mkdir -p  /var/run/php  /run/php  && \
     rm -rf /var/lib/apt/lists/*  && \
     rm -rf /var/cache/apt        && \
     echo "<?php phpinfo(); ?>"  > /var/www/html/index.php && \
     printf '#!/bin/bash\n\n# Start supervisord and services\nexec /usr/bin/supervisord -n -c /etc/supervisord.conf\n' \
        > /start.sh  && chmod +x /start.sh

COPY ./default   /etc/nginx/sites-enabled/default
COPY ./supervisord.conf    /etc/supervisord.conf

VOLUME [/var/www/html  /etc/nginx/sites-enabled   /var/log]
EXPOSE 80/tcp  443/tcp

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

