# proxy-ssllibev
Turns Raspberry Pi into SOCKS/HTTP/DNS proxy that tunnelling traffic via remote Shadowsocks server.

# How to use
```
$ docker run --name proxy-ssllibev -p 51080:1080 -p 55353:53/udp -p 58123:8123 -d samuelhbne/proxy-ssllibev -s 3.112.45.233 -p 8388 -b 0.0.0.0 -l 1080 -k "SSSLIBEV-PASS" -m "aes-256-gcm"
```
