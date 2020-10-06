# server-brook

Yet another unofficial [Brook](https://github.com/txthinking/brook) server installation scripts.

## [Optional] How to build server-brook docker image

```shell
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad/server-brook
$ docker build -t samuelhbne/server-brook:amd64 -f Dockerfile.amd64 .
...
```

### NOTE1

- Please replace "amd64" with the arch match the current box accordingly. For example: "arm64" for AWS ARM64 platform like A1, t4g instance or 64bit Ubuntu on Raspberry Pi. "arm" for 32bit Raspbian.

## How to start the container

```shell
$ docker run --rm -it samuelhbne/server-brook:amd64
server-brook -w|--password <password> [-p|--port <port-number>]
    -w|--password <password>      Password for brook server access
    -p|--port <port-num>          [Optional] Port number for brook server connection, default 6060
    -k|--hook <hook-url>          [Optional] URL to be hit before server execution, for DDNS update or notification
$ docker run --name server-brook -p 26060:6060 -d samuelhbne/server-brook:amd64 -w my-secret
...
```

### NOTE2

- Please replace "amd64" with the arch match the current box accordingly. For example: "arm64" for AWS ARM64 platform like A1, t4g instance or 64bit Ubuntu on Raspberry Pi. "arm" for 32bit Raspbian.
- Please replace 26060 with the TCP port number you want to listen for brook service.
- Please replace "my-secret" with the password you want to set for client auth.
- You can optionally assign a HOOK-URL to update the DDNS domain-name pointing to the current server public IP address.

## How to verify if server-brook is running properly

Please verify it from Ubuntu / Debian / Raspbian client host follow the instructions below.

### Please run the following instructions from Ubuntu / Debian / Raspbian client host for verifying

```shell
$ docker run --rm -it samuelhbne/proxy-brook:amd64
proxy-brook -s|--host <brook-server> -w|--password <password> [-p|--port <port-number>]
    -s|--server <brook-server>    brook server name or address
    -w|--password <password>      Password for brook server access
    -p|--port <port-num>          [Optional] Port number for brook server connection, default 6060
$ docker run --name proxy-brook -p 1080:1080 -p 65353:53/udp -p 8123:8123 -d samuelhbne/proxy-brook:amd64 -s 12.34.56.78 -p 26060 -w "my-secret"
...
$ curl -sSx socks5h://127.0.0.1:1080 http://ifconfig.co
12.34.56.78
```

### NOTE4

- First we ran proxy-sslibev as SOCKS5 proxy that tunneling traffic through your brook server.
- Then launching curl with client-IP address query through the proxy.
- This query was sent through your server with server-brook running.
- You should get the public IP address of your server with server-brook running if all good.
- Please have a look over the sibling project [proxy-brook](https://github.com/samuelhbne/vpn-launchpad/tree/master/proxy-brook) for more details.

## How to stop and remove the running container

```shell
$ docker stop server-brook
...
$ docker rm server-brook
...
```
