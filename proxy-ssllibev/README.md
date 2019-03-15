# proxy-ssllibev
SOCKS/HTTP/DNS proxy that tunnelling traffic via remote Shadowsocks server.

### How to build the image
```
$ docker build -t samuelhbne/proxy-ssllibev:adm64 -f Dockerfile.amd64 .
```

### How to start the container
```
$ docker run --name proxy-ssllibev -p ${SOCKS_PORT}:1080 -p ${DNS_PORT}:53/udp -p ${HTTP_PORT}:8123 -d samuelhbne/proxy-ssllibev:amd64 -s ${SS_SERVER} -p 8388 -b ${LISTEN_ADDR} -l 1080 -k "${SS_PASS}" -m "${SS_MTHD}"
```

### How to stop and remove the running container
```
$ docker stop proxy-ssllibev
$ docker rm proxy-ssllibev
```

### Standalone proxy deployment
```
$ cat server-ssslibev
SSMTHD=aes-256-gcm
SSPASS=SSSLIBEV-PASS
SSPORT=28388
$ cat proxy-ssllibev.env
VHOST=12.34.56.78
LSTNADDR="0.0.0.0"
SOCKSPORT="1080"
HTTPPORT="8123"
DNSPORT="65353"
$ ./proxy-ssllibev.sh
```
