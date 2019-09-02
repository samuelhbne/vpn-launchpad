# proxy-sslibev
SOCKS/HTTP/DNS proxy that tunnelling traffic via remote Shadowsocks server.

### How to build the image
```
$ docker build -t samuelhbne/proxy-sslibev:amd64 -f Dockerfile.amd64 .
```

### How to start the container
```
$ docker run --name proxy-sslibev -p ${SOCKS_PORT}:1080 -p ${DNS_PORT}:53/udp -p ${HTTP_PORT}:8123 -d samuelhbne/proxy-sslibev:amd64 -s ${SS_SERVER} -p 8388 -b ${LISTEN_ADDR} -l 1080 -k "${SS_PASS}" -m "${SS_MTHD}"
```

### How to stop and remove the running container
```
$ docker stop proxy-sslibev
$ docker rm proxy-sslibev
```

### Standalone proxy deployment
```
$ cat server-sslibev
SSMTHD=aes-256-gcm
SSPASS=SSSLIBEV-PASS
SSPORT=28388
$ cat proxy-sslibev.env
VHOST=12.34.56.78
LSTNADDR="0.0.0.0"
SOCKSPORT="1080"
HTTPPORT="8123"
DNSPORT="65353"
$ ./proxy-sslibev.sh
```
