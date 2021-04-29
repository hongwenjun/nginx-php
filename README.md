## 配置 Docker 容器  nginx-php-fpm7.3 镜像

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


-----

##  Dockerfile 文件  使用 supervisor 启动 php-fpm  和 nginx 服务
```
FROM  debian
CMD   bash
RUN   apt update -y && apt install -y  nginx php-fpm supervisor && \
      echo "<?php phpinfo(); ?>"  > /var/www/html/index.php && \
      mkdir -p  /var/run/php  /run/php

COPY ./default   /etc/nginx/sites-enabled/default
COPY ./supervisord.conf    /etc/supervisord.conf
ADD  ./start.sh    /

VOLUME [/var/www/html  /etc/nginx/sites-enabled]
EXPOSE 80/tcp  443/tcp

CMD ["/start.sh"]


```

-----

##  default 是 debian nginx 默认配置修改成启用  php-fpm
```
#   /etc/nginx/sites-enabled/default

##
# You should look at the following URL's in order to grasp a solid understanding
# of Nginx configuration files in order to fully unleash the power of Nginx.
# https://www.nginx.com/resources/wiki/start/
# https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/
# https://wiki.debian.org/Nginx/DirectoryStructure
#
# In most cases, administrators will remove this file from sites-enabled/ and
# leave it as reference inside of sites-available where it will continue to be
# updated by the nginx packaging team.
#
# This file will automatically load configuration files provided by other
# applications, such as Drupal or Wordpress. These applications will be made
# available underneath a path with that package name, such as /drupal8.
#
# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
##

# Default server configuration
#
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        # SSL configuration
        #
        # listen 443 ssl default_server;
        # listen [::]:443 ssl default_server;
        #
        # Note: You should disable gzip for SSL traffic.
        # See: https://bugs.debian.org/773332
        #
        # Read up on ssl_ciphers to ensure a secure configuration.
        # See: https://bugs.debian.org/765782
        #
        # Self signed certs generated by the ssl-cert package
        # Don't use them in a production server!
        #
        # include snippets/snakeoil.conf;

        root /var/www/html;

        # Add index.php to the list if you are using PHP
        index index.html index.php index.nginx-debian.html;

        server_name _;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }

        # pass PHP scripts to FastCGI server
        #
        location ~ .*\.php(\/.*)*$ {
                include snippets/fastcgi-php.conf;
        #
        #       # With php-fpm (or other unix sockets):
                fastcgi_pass unix:/run/php/php7.3-fpm.sock;
        #       # With php-cgi (or other tcp sockets):
        #       fastcgi_pass 127.0.0.1:9000;
        }

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #       deny all;
        #}
}


# Virtual Host configuration for example.com
#
# You can move that to a different file under sites-available/ and symlink that
# to sites-enabled/ to enable it.
#
#server {
#       listen 80;
#       listen [::]:80;
#
#       server_name example.com;
#
#       root /var/www/example.com;
#       index index.html;
#
#       location / {
#               try_files $uri $uri/ =404;
#       }
#}


```

