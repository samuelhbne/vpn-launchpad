# proxy-brook
SOCKS/HTTP/DNS proxy that tunnelling traffic via remote Brook server.

# How to use
```
$ docker build -t samuelhbne/proxy-brook:amd64 -f Dockerfile.amd64 .
$ docker run --name proxy-brook -p ${SOCKS_PORT}:1080 -p ${DNS_PORT}:53/udp -p ${HTTP_PORT}:8123 -d samuelhbne/proxy-brook:amd64 client -l 0.0.0.0:1080 -i 0.0.0.0 -s ${BROOK_SERVER_ADDR}:6060 -p ${BROOK_PASS}
```
