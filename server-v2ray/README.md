# server-v2ray

Yet another unofficial [v2ray](https://github.com/v2ray) server installation scripts.

## [Optional] How to build server-v2ray docker image

```shell
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad/server-v2ray
$ docker build -t samuelhbne/server-v2ray:amd64 -f Dockerfile.amd64 .
...
```

### NOTE1

- Please replace "amd64" with the arch match the current box accordingly. For example: "arm64" for AWS ARM64 platform like A1, t4g instance or 64bit Ubuntu on Raspberry Pi. "arm" for 32bit Raspbian.

## How to start the container

```shell
$ docker run --rm -it samuelhbne/server-v2ray:amd64
server-v2ray -u|--uuid <vmess-uuid> [-p|--port <port-num>] [-l|--level <level>] [-a|--alterid <alterid>] [-k|--hook hook-url]
    -u|--uuid <vmess-uuid>    Vmess UUID for initial V2ray connection
    -p|--port <port-num>      [Optional] Port number for incoming V2ray connection, default 10086
    -l|--level <level>        [Optional] Level number for V2ray service access, default 0
    -a|--alterid <alterid>    [Optional] AlterID number for V2ray service access, default 16
    -k|--hook <hook-url>      [Optional] URL to be hit before server execution, for DDNS update or notification
$ docker run --name server-v2ray -p 20086:10086 -d samuelhbne/server-v2ray:amd64 -u bec24d96-410f-4723-8b3b-46987a1d9ed8
...
```

### NOTE2

- Please replace "amd64" with the arch match the current box accordingly. For example: "arm64" for AWS ARM64 platform like A1, t4g instance or 64bit Ubuntu on Raspberry Pi. "arm" for 32bit Raspbian.
- Please replace "20086" with the TCP port number you want to listen for V2ray service.
- Please replace "bec24d96-410f-4723-8b3b-46987a1d9ed8" with the uuid you want to set for V2ray client auth.
- You can optionally assign a HOOK-URL to update the DDNS domain-name pointing to the current server public IP address.

## How to verify if server-v2ray is running properly

Try to connect the server from v2ray compatible mobile app like [v2rayNG](https://github.com/2dust/v2rayNG) for Android or [Shadowrocket](https://apps.apple.com/us/app/shadowrocket/id932747118) for iOS with the host-name, port, UUID, alterid etc. set above. Or verify it from Ubuntu / Debian / Raspbian client host follow the instructions below.

### Please run the following instructions from Ubuntu / Debian / Raspbian client host for verifying

```shell
$ docker run --rm -it samuelhbne/proxy-v2ray:amd64
proxy-v2ray -h|--host <v2ray-host> -u|--uuid <vmess-uuid> [-p|--port <port-num>] [-l|--level <level>] [-a|--alterid <alterid>] [-s|--security <client-security>]
    -h|--host <v2ray-host>            V2ray server host name or IP address
    -u|--uuid <vmess-uuid>            Vmess UUID for initial V2ray connection
    -p|--port <port-num>              [Optional] Port number for V2ray connection, default 10086
    -l|--level <level>                [Optional] Level number for V2ray service access, default 0
    -a|--alterid <alterid>            [Optional] AlterID number for V2ray service access, default 16
    -s|--security <client-security>   [Optional] V2ray client security setting, default 'auto'
$ docker run --name proxy-v2ray -p 1080:1080 -p 65353:53/udp -p 8123:8123 -d samuelhbne/proxy-v2ray:amd64 -h 12.34.56.78 -p 20086 -u bec24d96-410f-4723-8b3b-46987a1d9ed8
...

$ curl -sSx socks5h://127.0.0.1:1080 http://ifconfig.co
12.34.56.78
```

### NOTE4

- First we ran proxy-v2ray as SOCKS5 proxy that tunneling traffic through your v2ray server.
- Then launching curl with client-IP address query through the proxy.
- This query was sent through your server with server-v2ray running.
- You should get the public IP address of your server with server-v2ray running if all good.
- Please have a look over the sibling project [proxy-v2ray](https://github.com/samuelhbne/vpn-launchpad/tree/master/proxy-v2ray) for more details.

## How to stop and remove the running container

```shell
$ docker stop server-v2ray
...
$ docker rm server-v2ray
...
```
