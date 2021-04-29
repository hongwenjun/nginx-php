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

