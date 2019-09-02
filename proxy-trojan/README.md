# proxy-trojan
SOCKS/HTTP/DNS proxy that tunnelling traffic via remote Trojan server.

### How to build the image
```
$ docker build -t samuelhbne/proxy-trojan:amd64 -f Dockerfile.amd64 .
```

### How to Start Trojan proxy with help script (Recommended)

```
$ cat server-trojan.env
SGTCP="443"
TRJPORT="443"
TRJPASS="my-secret"
TRJFAKEDOMAIN="www.microsoft.com"
DUCKDNSTOKEN="0f8d8cb0-fec5-4339-8026-ca051cc0ce4a"
DUCKDNSDOMAIN="my-domain"
DUCKSUBDOMAINS="wildcard"

$ cat proxy-trojan.env
VHOST=12.34.56.78
LSTNADDR="0.0.0.0"
SOCKSPORT="1080"
HTTPPORT="8123"
DNSPORT="65353"

$ ./proxy-v2ray.sh
```

### How to start Trojan container manually
```
$ docker run --name proxy-trojan -p 1080:1080 -p 65353:53/udp -p 8123:8123 -d samuelhbne/proxy-trojan:amd64 -h 12.34.56.78 -d my-domain.duckdns.org -p 443 -w TROJAN_PASSWORD
```

### How to verify if proxy tunnel is working properly

```
$ curl -sx socks5h://127.0.0.1:1080 http://ifconfig.co
12.34.56.78

$ curl -sx http://127.0.0.1:8123 http://ifconfig.co
12.34.56.78

$ dig +short @127.0.0.1 -p 65353 twitter.com
104.244.42.193
104.244.42.129

$ whois 104.244.42.193|grep OrgId
OrgId:          TWITT
```
##### NOTE:
    -   curl supposed to return the VPN server address as you configured above
    -   dig supposed to return poison free IP recorders of twitter.com
    -   Depends on your region, whois may blocked hence failed the verification. Ignore that if so.

### How to stop and remove the running container
```
$ docker stop proxy-trojan
$ docker rm proxy-trojan
```
