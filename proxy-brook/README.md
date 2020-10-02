# proxy-brook

SOCKS/HTTP/DNS proxy that tunnelling traffic via remote Brook server.

## How to build the image

```shell
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad/proxy-brook
$ docker build -t samuelhbne/proxy-brook:amd64 -f Dockerfile.amd64 .
...
```

## How to start the container

```shell
$ docker run --name proxy-brook -p 1080:1080 -p 65353:53/udp -p 8123:8123 -d samuelhbne/proxy-brook:amd64 client --socks5 0.0.0.0:1080 -s 12.34.56.78:6060 -p my-secret
...
```

## How to verify if proxy tunnel is working properly

```shell
$ curl -sSx socks5h://127.0.0.1:1080 http://ifconfig.co
12.34.56.78

$ curl -sSx http://127.0.0.1:8123 http://ifconfig.co
12.34.56.78

$ dig +short @127.0.0.1 -p 65353 twitter.com
104.244.42.193
104.244.42.129

$ docker exec -it proxy-brook proxychains whois 104.244.42.193|grep OrgId
[proxychains] config file found: /etc/proxychains/proxychains.conf
[proxychains] preloading /usr/lib/libproxychains4.so
[proxychains] DLL init: proxychains-ng 4.14
[proxychains] Strict chain  ...  127.0.0.1:1080  ...  whois.arin.net:43  ...  OK
OrgId:          TWITT
```

### NOTE

- curl should return the VPN server address given above if SOCKS5/HTTP proxy works properly.
- dig should return resolved IP recorders of twitter.com if DNS server works properly.
- Whois should return "OrgId: TWITT". That means the IP address returned from dig query belongs to twitter.com indeed, hence untaminated.
- Whois was actually running inside the proxy container through proxychains to avoid potential access blocking.

## How to get the Brook QR code for mobile connection

```shell
$ docker exec -it proxy-brook /status.sh
VPS-Server: 12.34.56.78
Brook-URL: brook://12.34.56.78%3A6060%20my-secret
```

![QR code example](https://github.com/samuelhbne/vpn-launchpad/blob/master/images/qr-brook.png)

## How to stop and remove the running container

```shell
$ docker stop proxy-brook
...
$ docker rm proxy-brook
...
```
