# proxy-trojan

A SOCKS5/HTTP/DNS proxy that tunnelling traffic through existing Trojan VPN server.

## How to build the image

```shell
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad/proxy-trojan
$ docker build -t samuelhbne/proxy-trojan:amd64 -f Dockerfile.amd64 .
...
```

## How to start proxy-trojan container

```shell
$ docker run --rm -it samuelhbne/proxy-trojan:amd64
Usage: /run.sh -h <trojan-host> -w <password> [-p <port-number>]

$ docker run --name proxy-trojan -p 1080:1080 -p 65353:53/udp -p 8123:8123 -d samuelhbne/proxy-trojan:amd64 -h my-domain.duckdns.org -w my-secret -p 443
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
[proxychains] config file found: /etc/proxychains/proxychains.conf
[proxychains] preloading /usr/lib/libproxychains4.so
[proxychains] DLL init: proxychains-ng 4.14
[proxychains] Strict chain  ...  127.0.0.1:1080  ...  whois.arin.net:43  ...  OK
OrgId:          TWITT
```

### NOTE

- curl should return the VPN server address given above if SOCKS5/HTTP proxy work properly.
- dig should return poison free IP recorders of twitter.com if DNS server works properly.
- Whois should return "OrgId: TWITT". That means the IP recorder returned from dig query is untaminated.
- Whois was actually running inside the proxy container through proxychains to avoid potential access blocking.

## How to get the Trojan QR code for mobile connection

```shell
$ docker exec -it proxy-trojan /status.sh
VPS-Server: 12.34.56.78
Trojan-URL: trojan://my-secret@my-domain.duckdns.org:443
```

![QR code example](https://github.com/samuelhbne/vpn-launchpad/blob/master/images/qr-trojan.png)

## How to stop and remove the running container

```shell
$ docker stop proxy-trojan
...
$ docker rm proxy-trojan
```
