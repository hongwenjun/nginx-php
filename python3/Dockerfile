FROM debian:stable-slim
RUN  apt update -y \
  && apt install --no-install-recommends --no-install-suggests -y wget python3 python3-distutils \
  && apt install --no-install-recommends --no-install-suggests -y tmux  \
  && wget https://bootstrap.pypa.io/get-pip.py  --no-check-certificate  \
  && python3 get-pip.py \
  && apt clean  && apt autoremove  \
  && rm -rf /var/lib/apt/lists/*

RUN  mkdir -p /app && cd /app \ 
  && pip3 install requests mysql-connector \
  && pip3 install html2text  pillow   \
  && pip3 install beautifulsoup4  html5lib Flask ipip-ipdb \
  && wget https://git.io/me.py  --no-check-certificate \
  && wget https://raw.githubusercontent.com/hongwenjun/srgb/master/python/html2md.py --no-check-certificate \
  && wget https://raw.githubusercontent.com/hongwenjun/pillow_font/main/bitfont.py  --no-check-certificate \
  && rm -rf /usr/share/python-wheels/*

#   && python3 -m pip install --upgrade pip  \
#   && pip3 install setuptools  \
#   && pip3 install dnspython bson feedparser qbittorrent-api pymongo func_timeout honeybadger  \
#   && pip3 install scrapy  \

WORKDIR /app
EXPOSE 8000/tcp
CMD ["python3"]

################################################################################
#  docker build -t python3 .
#  docker run --rm -it python3
#  docker run --rm -it python3  python3  -i me.py
#  docker run --rm -it python3  python3  html2md.py  https://262235.xyz
#  docker build -t hongwenjun/python3 .
#  docker push hongwenjun/python3
################################################################################
#   docker run -d -p 8000:8000 --restart=always   \
#       -v /app:/app  --name python3 \
#       hongwenjun/python3  \
#       python3 -m http.server 8000
#
#   docker exec -it python3   bash
#   tmux -u
#   docker exec -it  python3   bash
#   tmux -u a
################################################################################
