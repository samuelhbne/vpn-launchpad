# server-ssslibev
Yet another unofficial [Shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev) server implementation.

# How to use

SSPORT:	Shadowsocks service port
SSPASS:	Shadowsocks password
SSMTHD:	Shadowsocks encrypt method

```
$ docker build -t samuelhbne/server-ssslibev:amd64 -f Dockerfile.amd64 .
$ docker run --restart unless-stopped --name server-ssslibev -p ${SSPORT}:8388 -p ${SSPORT}:8388/udp -d samuelhbne/server-ssslibev:amd64 -s 0.0.0.0 -s ::0 -p 8388 -k ${SSPASS} -m ${SSMTHD} -t 300 --fast-open -d 8.8.8.8,8.8.4.4 -u
```
