# proxy-brook
SOCKS/HTTP/DNS proxy that tunnelling traffic via remote Brook server.

# How to use
```
$ docker run --name proxy-brook -p 51080:1080 -p 55353:53/udp -p 58123:8123 -d samuelhbne/proxy-brook client -l 0.0.0.0:1080 -i 0.0.0.0 -s 3.112.45.233:6060 -p BROOK-PASS
```
