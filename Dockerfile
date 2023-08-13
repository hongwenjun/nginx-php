FROM debian:stable-slim
RUN  apt update -y && \
     apt install -y --no-install-recommends --no-install-suggests nginx supervisor wget  \
     php8.2 php8.2-fpm php8.2-sqlite3 php8.2-xml php8.2-zip php8.2-pgsql php8.2-mbstring  \
     php8.2-bcmath php8.2-mysql php8.2-gd php8.2-cli php8.2-curl php8.2-cgi && \
     mkdir -p  /var/run/php  /run/php  /etc/nginx/cert && \
     wget https://raw.githubusercontent.com/hongwenjun/nginx-php/main/start.sh         --no-check-certificate && \
     wget https://raw.githubusercontent.com/hongwenjun/nginx-php/main/default          --no-check-certificate  && \
     wget https://raw.githubusercontent.com/hongwenjun/nginx-php/main/supervisord.conf --no-check-certificate   && \
     mv ./default  /etc/nginx/sites-enabled/default  && \
     mv ./supervisord.conf   /etc/supervisord.conf   && \
     chmod +x  /start.sh  && \
     ln -sf /dev/stdout /var/log/nginx/access.log  && \
     ln -sf /dev/stderr /var/log/nginx/error.log   && \
     echo "<?php phpinfo(); ?>"  > /var/www/html/index.php && \
     apt remove -y wget && \
     rm -rf /var/lib/apt/lists/*   /var/cache/apt  && \
     cd /etc/php/8.2/fpm  && \
     sed -i 's/post_max_size = 8M/post_max_size = 80M/g'  php.ini && \
     sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 80M/g'  php.ini


EXPOSE 80/tcp  443/tcp
# VOLUME [ /var/www/html  /etc/nginx/conf.d  /etc/nginx/cert ]

# COPY ./default             /etc/nginx/sites-enabled/default
# COPY ./supervisord.conf    /etc/supervisord.conf
# COPY ./start.sh            /start.sh

CMD ["/start.sh"]

