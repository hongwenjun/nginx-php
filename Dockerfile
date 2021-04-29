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


