# proxy-v2ray
SOCKS/HTTP/DNS proxy that tunnelling traffic via remote v2ray server.

# How to use
```
$ docker run --name proxy-v2ray -p 51080:1080 -p 55353:53/udp -p 58123:8123 -d samuelhbne/proxy-v2ray -h 3.112.45.233 -p 10086 -u e6daf07f-15f1-4785-8a7f-7aeeae446bdb -l 0.0.0.0 -k 1080
```
