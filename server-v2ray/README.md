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

- Please replace Dockerfile.amd64 with the Dockerfile.ARCH match the current server accordingly. For example: Dockerfile.arm64 for AWS ARM64 platform like A1 and t4g instance or 64bit Ubuntu on Raspberry Pi. Dockerfile.arm for 32bit Raspbian.

## How to start the container

```shell
$ docker run --rm -it samuelhbne/server-v2ray:amd64
server-v2ray -u|--uuid <vmess-uuid> [-p|--port <port-num>] [-l|--level <level>] [-a|--alterid <alterid>] [-k|--hook hook-url]
    -u|--uuid <vmess-uuid>    Vmess UUID for initial V2ray connection
    -p|--port <port-num>      [optional] Port number for incoming V2ray connection
    -l|--level <level>        [optional] Level number for V2ray service access, default to be 0
    -a|--alterid <alterid>    [optional] AlterID number for V2ray service access, default to be 16
    -k|--hook <hook-url>      [optional] URL to be hit before server execution, for DDNS update or notification
$ docker run --name server-v2ray -p 10086:10086 -d samuelhbne/server-v2ray:amd64 -u bec24d96-410f-4723-8b3b-46987a1d9ed8
...
```

### NOTE2

- Please replace "10086" with the port you want to listen.
- Please replace "bec24d96-410f-4723-8b3b-46987a1d9ed8" with the uuid you want to set.
- You can optionally assign a HOOK-URL from command line to update DDNS domain-name pointing to the current server public IP address.

## How to stop and remove the running container

```shell
$ docker stop server-v2ray
...
$ docker rm server-v2ray
...
```
