# server-sslibev

Yet another unofficial [Shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev) server installation scripts.

## How to build the image

```shell
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad/server-sslibev
$ docker build -t samuelhbne/server-sslibev:amd64 -f Dockerfile.amd64 .
...
```

### NOTE1

- Please replace Dockerfile.amd64 with the Dockerfile.ARCH match the current server accordingly. For example: Dockerfile.arm for 32bit Raspbian, Dockerfile.arm64 for 64bit Ubuntu for Raspberry Pi.

## How to start the container

```shell
$ docker run --rm -it samuelhbne/server-sslibev:amd64 --help
shadowsocks-libev 3.3.4
...
$ docker run --name server-sslibev -p 28388:8388 -p 28388:8388/udp -d samuelhbne/server-sslibev:amd64 -s 0.0.0.0 -s ::0 -p 8388 -k my-secret -m aes-256-gcm -t 300 --fast-open -d 8.8.8.8,8.8.4.4 -u
...
```

### NOTE2

- Please ensure your server port TCP 28388 is reachable.
- Please replace 28388 with the TCP port number you want to listen.
- Please replace "my-secret" with the password you want to set.
- Please replace "aes-256-gcm" with the encrypt method you want to set.

## How to stop and remove the running container

```shell
$ docker stop server-sslibev
...
$ docker rm server-sslibev
...
```
