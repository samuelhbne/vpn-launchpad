# proxy-sslibev

SOCKS/HTTP/DNS proxy that tunnelling traffic via remote Shadowsocks server.

## How to build the image

```shell
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad/proxy-sslibev
$ docker build -t samuelhbne/proxy-sslibev:amd64 -f Dockerfile.amd64 .
...
```

### NOTE1

- Please replace Dockerfile.amd64 with the Dockerfile.ARCH match the current server accordingly. For example: Dockerfile.arm for 32bit Raspbian, Dockerfile.arm64 for 64bit Ubuntu for Raspberry Pi.

## How to start the container

```shell
$ docker run --rm -it samuelhbne/proxy-sslibev:amd64
proxy-sslibev -s|--host <sslibev-server> -w|--password <password> [-p|--port <port-number>] [-m|--method <encrypt-method>] [-t|--timeout <timeout-seconds>]
    -s|--server <sslibev-server>      sslibev server name or address
    -w|--password <password>          Password for sslibev server access
    -p|--port <port-num>              [Optional] Port number for sslibev server connection, default 8388
    -m|--method <encrypt-method>      [Optional] Encrypt method used by sslibev server, default aes-256-gcm
    -t|--timeout <timeout-seconds>    [Optional] Connection timeout in seconds
$ docker run --name proxy-sslibev -p 1080:1080 -p 65353:53/udp -p 8123:8123 -d samuelhbne/proxy-sslibev:amd64 -s 12.34.56.78 -w "my-secret"
...
```

### NOTE2

- Please replace "12.34.56.78" with the shadowsocks server you want to connect
- Please replace 8388 with the shadowsocks service port you want to connect
- Please replace 65353 with the UDP port number you want to listen for DNS service.
- Please replace "my-secret" with the password you want to set.
- Please replace "aes-256-gcm" with the encrypt method you want to set.

## How to stop and remove the running container

```shell
$ docker stop proxy-sslibev
...
$ docker rm proxy-sslibev
...
```
