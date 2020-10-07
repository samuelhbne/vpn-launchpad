# proxy-sslibev

SOCKS/HTTP/DNS proxy that tunnelling traffic via remote Shadowsocks server.

## [Optional] How to build proxy-sslibev docker image

```shell
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad/proxy-sslibev
$ docker build -t samuelhbne/proxy-sslibev:amd64 -f Dockerfile.amd64 .
...
```

### NOTE1

- Please replace "amd64" with the arch match the current box accordingly. For example: "arm64" for AWS ARM64 platform like A1, t4g instance or 64bit Ubuntu on Raspberry Pi. "arm" for 32bit Raspbian.

## How to start proxy-sslibev container

```shell
$ docker run --rm -it samuelhbne/proxy-sslibev:amd64
proxy-sslibev -s|--host <sslibev-server> -w|--password <password> [-p|--port <port-number>] [-m|--method <encrypt-method>] [-t|--timeout <timeout-seconds>]
    -s|--server <sslibev-server>      sslibev server name or address
    -w|--password <password>          Password for sslibev server access
    -p|--port <port-num>              [Optional] Port number for sslibev server connection, default 8388
    -m|--method <encrypt-method>      [Optional] Encrypt method used by sslibev server, default aes-256-gcm
    -t|--timeout <timeout-seconds>    [Optional] Connection timeout in seconds
$ docker run --name proxy-sslibev -p 21080:1080 -p 65353:53/udp -p 28123:8123 -d samuelhbne/proxy-sslibev:amd64 -s 12.34.56.78 -w "my-secret" -m aes-256-gcm
...
```

### NOTE2

- Please replace "amd64" with the arch match the current box accordingly. For example: "arm64" for AWS ARM64 platform like A1, t4g instance or 64bit Ubuntu on Raspberry Pi. "arm" for 32bit Raspbian.
- Please replace "12.34.56.78" with the shadowsocks server hotsname/IP you want to connect
- Please replace "my-secret" with the password you want to set.
- Please replace "aes-256-gcm" with the encrypt method you want to set.
- Please replace 21080 with the port number you want for SOCKS5 proxy TCP listerning.
- Please replace 28123 with the port number you want for HTTP proxy TCP listerning.
- Please replace 65353 with the port number you want for DNS UDP listerning.

Full list of Shadowsocks encryption methods can be found here:

```shell
$ docker run --rm --entrypoint /usr/bin/ss-local -it samuelhbne/proxy-sslibev:amd64 --help
...
       -m <encrypt_method>        Encrypt method: rc4-md5,
                                  aes-128-gcm, aes-192-gcm, aes-256-gcm,
                                  aes-128-cfb, aes-192-cfb, aes-256-cfb,
                                  aes-128-ctr, aes-192-ctr, aes-256-ctr,
                                  camellia-128-cfb, camellia-192-cfb,
                                  camellia-256-cfb, bf-cfb,
                                  chacha20-ietf-poly1305,
                                  xchacha20-ietf-poly1305,
                                  salsa20, chacha20 and chacha20-ietf.
                                  The default cipher is chacha20-ietf-poly1305.
...
```

## How to verify if proxy tunnel is working properly

```shell
$ curl -sSx socks5h://127.0.0.1:21080 http://ifconfig.co
12.34.56.78

$ curl -sSx http://127.0.0.1:28123 http://ifconfig.co
12.34.56.78

$ dig +short @127.0.0.1 -p 65353 twitter.com
104.244.42.193
104.244.42.129

$ docker exec -it proxy-trojan proxychains whois 104.244.42.193|grep OrgId
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
- Please have a look over the sibling project [server-sslibev](https://github.com/samuelhbne/vpn-launchpad/tree/master/server-sslibev) if you'd like to set a Shadowsocks server.

## How to get the Shadowsocks QR code for mobile connection

```shell
$ docker exec -it proxy-sslibev /status.sh
VPS-Server: 12.34.56.78
Shadowsocks-URL: ss://YWVzLTI1Ni1nY206bXktc2VjcmV0@:8388#VLP-shadowsocks
```

![QR code example](https://github.com/samuelhbne/vpn-launchpad/blob/master/images/qr-sslibev.png)

## How to stop and remove the running container

```shell
$ docker stop proxy-sslibev
...
$ docker rm proxy-sslibev
...
```
