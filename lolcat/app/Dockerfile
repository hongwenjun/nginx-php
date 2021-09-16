#    _          _           _
#   | |    ___ | | ___ __ _| |_
#   | |   / _ \| |/ __/ _` | __|
#   | |__| (_) | | (_| (_| | |_
#   |_____\___/|_|\___\__,_|\__|
#

FROM alpine:latest  AS builder
RUN  apk add ruby; gem install lolcat;   \
     apk del ca-certificates ruby-dev;    \
     rm -rf /usr/share/terminfo /usr/share/ca-certificates /var/cache /etc/ssl \
        /etc/terminfo /lib/libssl.so.1.1 /lib/libcrypto.so.1.1   \
        /usr/lib/ruby/gems/2.7.0/cache /usr/lib/ruby/2.7.0/x86_64-linux-musl/enc
             
FROM scratch
COPY --from=builder  .  .
ADD  ./app  /app
WORKDIR  /app

ENTRYPOINT ["lolcat"]

# docker build -t lolcat  .
# docker run --rm -it  lolcat -h
# docker run --rm -it  lolcat Dockerfile
# docker run --rm -it -v $(pwd):/app/ lolcat Dockerfile

