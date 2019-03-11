# proxy-v2ray
SOCKS/HTTP/DNS proxy that tunnelling traffic via remote v2ray server.

# How to use
```
$ docker build -t samuelhbne/proxy-v2ray:amd64 -f Dockerfile.amd64 .
$ docker run --name proxy-v2ray -p ${SOCKS_PORT}:1080 -p ${DNS_PORT}:53/udp -p ${HTTP_PORT}:8123 -d samuelhbne/proxy-v2ray:amd64 -h ${V2RAY_SERVER_ADDR} -p ${V2RAY_SERVER_PORT} -u ${V2RAY_UUID} -l 0.0.0.0 -k 1080
```
