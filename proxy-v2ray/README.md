# proxy-v2ray
SOCKS/HTTP/DNS proxy that tunnelling traffic via remote v2ray server.

### How to build the image
```
$ docker build -t samuelhbne/proxy-v2ray:amd64 -f Dockerfile.amd64 .
```

### How to start the container
```
$ docker run --name proxy-v2ray -p ${SOCKS_PORT}:1080 -p ${DNS_PORT}:53/udp -p ${HTTP_PORT}:8123 -d samuelhbne/proxy-v2ray:amd64 -h ${V2RAY_SERVER_ADDR} -p ${V2RAY_SERVER_PORT} -u ${V2RAY_UUID} -l 0.0.0.0 -k 1080
```

### How to stop and remove the running container
```
$ docker stop proxy-v2ray
$ docker rm proxy-v2ray
```

### Standalone proxy deployment
```
$ cat server-v2ray.env
V2RAYAID=64
V2RAYLEVEL=1
V2RAYPORT=10086
V2RAYUUID=e6daf07f-15f1-4785-8a7f-7aeeae446bdb
$ cat proxy-v2ray.env
VHOST=12.34.56.78
LSTNADDR="0.0.0.0"
SOCKSPORT="1080"
HTTPPORT="8123"
DNSPORT="65353"
V2RAYSECURITY="auto"
$ ./proxy-v2ray.sh
```
