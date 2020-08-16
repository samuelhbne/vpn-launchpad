# proxy-v2ray

A SOCKS/HTTP/DNS proxy that tunnelling traffic through existing V2Ray VPN server.

## How to build the image

```shell
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad/proxy-v2ray
$ docker build -t samuelhbne/proxy-v2ray:amd64 -f Dockerfile.amd64 .
...
```

### NOTE1

- Please replace Dockerfile.amd64 with the Dockerfile.ARCH match your server accordingly. For example: Dockerfile.arm for 32bit Raspbian, Dockerfile.arm64 for 64bit Ubuntu for Raspberry Pi.

## How to start the container

```shell
$ docker run --rm -it samuelhbne/proxy-v2ray:amd64
Usage: /run.sh -h <v2ray-host> -u <uuid> [-p <port-numbert>] [-a <alterid>] [-l <level>] [-s <security>]

$ docker run --name proxy-v2ray -p 1080:1080 -p 65353:53/udp -p 8123:8123 -d samuelhbne/proxy-v2ray:amd64 -h 12.34.56.78 -p 10086 -u bec24d96-410f-4723-8b3b-46987a1d9ed8
...
```

### NOTE2

- Please replace "10086" with the port you want to connect to.
- Please replace "bec24d96-410f-4723-8b3b-46987a1d9ed8" with the uuid you want to set.

## How to verify if proxy tunnel is working properly

```shell
$ curl -sx socks5h://127.0.0.1:1080 http://ifconfig.co
12.34.56.78

$ curl -sx http://127.0.0.1:8123 http://ifconfig.co
12.34.56.78

$ dig +short @127.0.0.1 -p 65353 twitter.com
104.244.42.193
104.244.42.129

$ docker exec -it proxy-v2ray proxychains whois 104.244.42.193|grep OrgId
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

## How to get the V2Ray QR code for mobile connection

```shell
$ docker exec -it proxy-v2ray /status.sh
VPS-Server: 12.34.56.78
V2Ray-vmess-URI: vmess://eydhZGQnOicxMi4zNC41Ni43OCcsJ2FpZCc6JzE2JywnaWQnOidiZWMyNGQ5Ni00MTBmLTQ3MjMtOGIzYi00Njk4N2ExZDllZDgnLCduZXQnOid0Y3AnLCdwb3J0JzonMTAwODYnLCdwcyc6J1ZMUC1WMlJBWSd9Cg==
```

![QR code example](https://github.com/samuelhbne/vpn-launchpad/blob/master/images/qr-v2ray.png)

## How to stop and remove the running container

```shell
$ docker stop proxy-v2ray
...
$ docker rm proxy-v2ray
...
```
