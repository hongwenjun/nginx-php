FROM debian:stable-slim
RUN  apt update -y && \
     apt install -y --no-install-recommends --no-install-suggests nginx supervisor wget  \
     php7.4 php7.4-fpm php7.4-sqlite3 php7.4-xml php7.4-zip php7.4-pgsql php7.4-mbstring  \
     php7.4-bcmath php7.4-json php7.4-mysql php7.4-gd php7.4-cli php7.4-curl php7.4-cgi && \
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
     rm -rf /var/lib/apt/lists/*   /var/cache/apt

EXPOSE 80/tcp  443/tcp
# VOLUME [ /var/www/html  /etc/nginx/conf.d  /etc/nginx/cert ]

# COPY ./default             /etc/nginx/sites-enabled/default
# COPY ./supervisord.conf    /etc/supervisord.conf
# COPY ./start.sh            /start.sh

CMD ["/start.sh"]

