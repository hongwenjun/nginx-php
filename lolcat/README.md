![Dockerfile](https://github.com/hongwenjun/nginx-php/blob/main/lolcat/lolcat.png)

### Build
```
wget -O lolcat.tgz  https://github.com/hongwenjun/nginx-php/raw/main/lolcat/lolcat.tgz
tar xf lolcat.tgz
docker build -t lolcat  .
docker run --rm -it  lolcat Dockerfile
```

### Usage
```
docker run --rm -it -v $(pwd):/app/ \
    hongwenjun/lolcat  README.md
```

### `Dockerfile`
```
#    _          _           _
#   | |    ___ | | ___ __ _| |_
#   | |   / _ \| |/ __/ _` | __|
#   | |__| (_) | | (_| (_| | |_
#   |_____\___/|_|\___\__,_|\__|
#

FROM jamesnetherton/lolcat  AS builder
RUN  apk del ca-certificates ruby-dev musl-dev gcc make; rm -rf  /usr/share/terminfo \
         /usr/share/ca-certificates /etc/ssl /etc/terminfo /lib/libssl.so.1.1
             
FROM scratch
COPY --from=builder  .  .
ADD  ./app  /app
WORKDIR  /app

ENTRYPOINT ["lolcat"]

# docker build -t lolcat  .
# docker run --rm -it  lolcat -h
# docker run --rm -it  lolcat Dockerfile
# docker run --rm -it -v $(pwd):/app/ lolcat Dockerfile

```
