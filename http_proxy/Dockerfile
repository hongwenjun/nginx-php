FROM debian:stable-slim
RUN  apt update -y \
  && apt install --no-install-recommends --no-install-suggests -y wget shadowsocks-libev supervisor \
  && wget  -O /usr/bin/brook  https://github.com/txthinking/brook/releases/download/v20210701/brook_linux_amd64  --no-check-certificate \
  && chmod +x /usr/bin/brook \
  && apt remove -y wget \
  && rm -rf /var/lib/apt/lists/*   /var/cache/apt

ADD  http_proxy.tar.gz  /

CMD ["/start.sh"]

##############################################################################
#  tar cvzf http_proxy.tar.gz  etc/*  http.sh  start.sh
#  docker build -t http_proxy  .

#  docker run -d -p 58010:58010 --restart=always --name http_proxy  http_proxy
##############################################################################

