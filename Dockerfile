FROM debian:stable-slim
RUN  apt update -y && \
     apt install -y --no-install-recommends --no-install-suggests nginx supervisor wget  \
     php7.3 php7.3-fpm php7.3-sqlite3 php7.3-xml php7.3-zip php7.3-pgsql php7.3-mbstring  \
     php7.3-bcmath php7.3-json php7.3-mysql php7.3-gd php7.3-cli php7.3-curl php7.3-cgi && \
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

