![](https://262235.xyz/usr/uploads/2021/08/2281641762.png)

#  Python3  With  Network Library ( html2text scrapy beautifulsoup4 ipip-ipdb )

##  Usage ,  Run Container in Background
```
docker run -d  --restart=always   \
    -v /app:/app  --name python3 \
    hongwenjun/python3  sh
```

##  Run a command in a running container
```
docker exec -it  python3   bash
tmux -u
tmux -u a
```

## os sys html2text library
```
python3  -i me.py
python3  html2md.py  https://www.262235.xyz/index.php/archives/242/
```
## Scrapy Shell 
```
scrapy shell 'https://262235.xyz'

fetch("https://www.262235.xyz/index.php/archives/242/")

response.xpath('/html/body/section/div/div').get()

import html2text

html = response.xpath('/html/body/section/div/div').get()
text = html2text.html2text(html)
print(text)
```

## Dockerfile
```
FROM debian:stable-slim
RUN  apt update -y \
  && apt install --no-install-recommends --no-install-suggests -y wget python3 python3-pip \
  && apt install --no-install-recommends --no-install-suggests -y tmux  \
  && apt-get clean  \
  && apt-get autoremove  \
  && rm -rf /var/lib/apt/lists/*  \
  && wget https://git.io/me.py  \
  && wget https://raw.githubusercontent.com/hongwenjun/srgb/master/python/html2md.py  \
  && python3 -m pip install --upgrade pip  \
  && pip3 install setuptools  \
  && pip3 install --upgrade  pip  requests  \
  && pip3 install html2text  \
  && pip3 install dnspython bson feedparser qbittorrent-api pymongo func_timeout honeybadger  \
  && pip3 install scrapy  \
  && pip3 install beautifulsoup4  html5lib  ipip-ipdb


EXPOSE 8000/tcp

VOLUME  /app

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
#       hongwenjun/python3 sh
#
#   docker exec -it python3   bash
#
#   tmux -u
#   docker exec -it  python3   bash
#   tmux -u a

################################################################################

```
