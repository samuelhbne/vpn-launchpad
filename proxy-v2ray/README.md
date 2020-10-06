# proxy-v2ray

A SOCKS/HTTP/DNS proxy that tunnelling traffic through existing V2Ray VPN server.

## [Optional] How to build proxy-v2ray docker image

```shell
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad/proxy-v2ray
$ docker build -t samuelhbne/proxy-v2ray:amd64 -f Dockerfile.amd64 .
...
```

### NOTE1

- Please replace Dockerfile.amd64 with the Dockerfile.ARCH match your server accordingly. For example: Dockerfile.arm for 32bit Raspbian, Dockerfile.arm64 for 64bit Ubuntu for Raspberry Pi.

## How to start proxy-v2ray container

```shell
$ docker run --rm -it samuelhbne/proxy-v2ray:amd64
proxy-v2ray -h|--host <v2ray-host> -u|--uuid <vmess-uuid> [-p|--port <port-num>] [-l|--level <level>] [-a|--alterid <alterid>] [-s|--security <client-security>]
    -h|--host <v2ray-host>            V2ray server host name or IP address
    -u|--uuid <vmess-uuid>            Vmess UUID for initial V2ray connection
    -p|--port <port-num>              [Optional] Port number for V2ray connection, default 10086
    -l|--level <level>                [Optional] Level number for V2ray service access, default 0
    -a|--alterid <alterid>            [Optional] AlterID number for V2ray service access, default 16
    -s|--security <client-security>   [Optional] V2ray client security setting, default 'auto'
$ docker run --name proxy-v2ray -p 21080:1080 -p 65353:53/udp -p 28123:8123 -d samuelhbne/proxy-v2ray:amd64 -h 12.34.56.78 -u bec24d96-410f-4723-8b3b-46987a1d9ed8
...
```

### NOTE2

- Please replace "amd64" with the arch match the current box accordingly. For example: "arm64" for AWS ARM64 platform like A1, t4g instance or 64bit Ubuntu on Raspberry Pi. "arm" for 32bit Raspbian.
- Please replace "12.34.56.78" with the v2ray server hotsname/IP you want to connect
- Please replace 21080 with the port number you want for SOCKS5 proxy TCP listerning.
- Please replace 28123 with the port number you want for HTTP proxy TCP listerning.
- Please replace 65353 with the port number you want for DNS UDP listerning.
- Please replace "bec24d96-410f-4723-8b3b-46987a1d9ed8" with the uuid you want to set for V2ray server access.

## How to verify if proxy tunnel is working properly

```shell
$ curl -sSx socks5h://127.0.0.1:21080 http://ifconfig.co
12.34.56.78

$ curl -sSx http://127.0.0.1:28123 http://ifconfig.co
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
- Whois was actually running inside the proxy container through the proxy tunnel to avoid potential access blocking.
- Please have a look over the sibling project [server-v2ray](https://github.com/samuelhbne/vpn-launchpad/tree/master/server-v2ray) if you'd like to set a V2ray server.

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
