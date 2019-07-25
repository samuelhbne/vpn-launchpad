# server-sslibev
Yet another unofficial [Shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev) server installation scripts.

### How to build the image
```
$ docker build -t samuelhbne/server-sslibev:amd64 -f Dockerfile.amd64 .
```

### How to start the container
```
$ docker run --restart unless-stopped --name server-sslibev -p ${SSPORT}:8388 -p ${SSPORT}:8388/udp -d samuelhbne/server-sslibev:amd64 -s 0.0.0.0 -s ::0 -p 8388 -k ${SSPASS} -m ${SSMTHD} -t 300 --fast-open -d 8.8.8.8,8.8.4.4 -u
```

### How to stop and remove the running container
```
$ docker stop server-sslibev
$ docker rm server-sslibev
```

### Standalone server deployment
```
$ cat server-sslibev.env
SSPASS="SSSLIBEV-PASS"
SSMTHD="aes-256-gcm"
$ ./server-sslibev.sh
```
