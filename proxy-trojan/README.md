# proxy-trojan

SOCKS/HTTP/DNS proxy that tunnelling traffic via remote Trojan server.

## How to build the image

```shell
$ docker build -t samuelhbne/proxy-trojan:amd64 -f Dockerfile.amd64 .
...
```

## How to Start Trojan proxy with help script (Recommended)

```shell
$ cat server-trojan.env
SGTCP="443"
TRJPORT="443"
TRJPASS="my-secret"
TRJFAKEDOMAIN="www.microsoft.com"
DUCKDNSTOKEN="0f8d8cb0-fec5-4339-8026-ca051cc0ce4a"
DUCKDNSDOMAIN="my-domain"
DUCKSUBDOMAINS="wildcard"
VHOST="my-domain.duckdns.org"

$ cat proxy-trojan.env
LSTNADDR="0.0.0.0"
SOCKSPORT="1080"
HTTPPORT="8123"
DNSPORT="65353"

$ ./proxy-trojan.sh
...
```

## How to start Trojan container manually

```shell
$ docker run --name proxy-trojan -p 1080:1080 -p 65353:53/udp -p 8123:8123 -d samuelhbne/proxy-trojan:amd64 -h my-domain.duckdns.org -p 443 -w TROJAN_PASSWORD
...
```

## How to verify if proxy tunnel is working properly

```shell
$ curl -sx socks5h://127.0.0.1:1080 http://ifconfig.co
12.34.56.78

$ curl -sx http://127.0.0.1:8123 http://ifconfig.co
12.34.56.78

$ dig +short @127.0.0.1 -p 65353 twitter.com
104.244.42.193
104.244.42.129

$ docker exec -it proxychains whois 104.244.42.193|grep OrgId
OrgId:          TWITT
```

### NOTE

- curl should return the VPN server address as you configured above if all good.
- dig should return poison free IP recorders of twitter.com if all good.
- Whois should return "OrgId: TWITT" if all good. That means the IP recorder returned from dig query is untaminated.
- Whois was actually running inside the proxy container and proxyfied via proxychains to avoid potential access blocking.

## How to stop and remove the running container

```shell
$ docker stop proxy-trojan
...
$ docker rm proxy-trojan
```
