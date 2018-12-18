# server-ssslibev
[Shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev) server implementation.

# How to use
```
$ docker run --restart unless-stopped --name server-ssslibev -p 8388:8388 -p 8388:8388/udp -d samuelhbne/server-ssslibev -s 0.0.0.0 -s ::0 -p 8388 -k SSPASS -m SSMTHD -t 300 --fast-open -d 8.8.8.8,8.8.4.4 -u
```
