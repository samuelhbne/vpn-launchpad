# proxy-brook

SOCKS/HTTP/DNS proxy that tunnelling traffic via remote Brook server.

## [Optional] How to build proxy-brook docker image

```shell
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad/proxy-brook
$ docker build -t samuelhbne/proxy-brook:amd64 -f Dockerfile.amd64 .
...
```

### NOTE1

- Please replace "amd64" with the arch match the current box accordingly. For example: "arm64" for AWS ARM64 platform like A1, t4g instance or 64bit Ubuntu on Raspberry Pi. "arm" for 32bit Raspbian.

## How to start proxy-brook container

```shell
$ docker run --rm -it samuelhbne/proxy-brook:amd64
proxy-brook -s|--host <brook-server> -w|--password <password> [-p|--port <port-number>]
    -s|--server <brook-server>    brook server name or address
    -w|--password <password>      Password for brook server access
    -p|--port <port-num>          [Optional] Port number for brook server connection, default 6060
$ docker run --name proxy-brook -p 21080:1080 -p 65353:53/udp -p 28123:8123 -d samuelhbne/proxy-brook:amd64 -s 12.34.56.78 -w my-secret
...
```

### NOTE2

- Please replace "amd64" with the arch match the current box accordingly. For example: "arm64" for AWS ARM64 platform like A1, t4g instance or 64bit Ubuntu on Raspberry Pi. "arm" for 32bit Raspbian.
- Please replace "12.34.56.78" with the brook server hotsname/IP you want to connect
- Please replace "my-secret" with the password you want to set.
- Please replace 21080 with the port number you want for SOCKS5 proxy TCP listerning.
- Please replace 28123 with the port number you want for HTTP proxy TCP listerning.
- Please replace 65353 with the port number you want for DNS UDP listerning.

## How to verify if proxy tunnel is working properly

```shell
$ curl -sSx socks5h://127.0.0.1:21080 http://ifconfig.co
12.34.56.78

$ curl -sSx http://127.0.0.1:28123 http://ifconfig.co
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

### NOTE3

- curl should return the VPN server address given above if SOCKS5/HTTP proxy works properly.
- dig should return resolved IP recorders of twitter.com if DNS server works properly.
- Whois should return "OrgId: TWITT". That means the IP address returned from dig query belongs to twitter.com indeed, hence untaminated.
- Whois was actually running inside the proxy container through proxychains to avoid potential access blocking.
- Please have a look over the sibling project [server-brook](https://github.com/samuelhbne/vpn-launchpad/tree/master/server-brook) if you'd like to set a Shadowsocks server.

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
