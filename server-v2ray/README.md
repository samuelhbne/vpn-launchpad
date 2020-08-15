# server-v2ray

Yet another unofficial [v2ray](https://github.com/v2ray) server installation scripts.

## How to build the image

```shell
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad/server-v2ray
$ docker build -t samuelhbne/server-v2ray:amd64 -f Dockerfile.amd64 .
...
```

### NOTE1

- Please replace Dockerfile.amd64 with the Dockerfile.ARCH match your server accordingly. For example: Dockerfile.arm for 32bit Raspbian, Dockerfile.arm64 for 64bit Ubuntu for Raspberry Pi.

## How to start the container

```shell
$ docker run --rm -it samuelhbne/server-v2ray:amd64
Usage: /run.sh -u <client uuid> [-p <port numbert>] [-v <level>] [-a <alterid>]

$ docker run --name server-v2ray -p 10086:10086 -d samuelhbne/server-v2ray:amd64 -p 10086 -u bec24d96-410f-4723-8b3b-46987a1d9ed8
...
```

### NOTE2

- Please replace "10086" with the port you want to listen.
- Please replace "bec24d96-410f-4723-8b3b-46987a1d9ed8" with the uuid you want to set.

## How to stop and remove the running container

```shell
$ docker stop server-v2ray
...
$ docker rm server-v2ray
...
```
