# server-brook

Yet another unofficial [Brook](https://github.com/txthinking/brook) server installation scripts.

## How to build the image

```shell
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad/server-brook
$ docker build -t samuelhbne/server-brook:amd64 -f Dockerfile.amd64 .
...
```

### NOTE1

- Please replace Dockerfile.amd64 with the Dockerfile.ARCH match the current server accordingly. For example: Dockerfile.arm for 32bit Raspbian, Dockerfile.arm64 for 64bit Ubuntu for Raspberry Pi.

## How to start the container

```shell
$ docker run --name server-brook -p 26060:6060 -d samuelhbne/server-brook:amd64 server -l :6060 -p my-secret
...
```

### NOTE2

- Please ensure your server port TCP 26060 is reachable.
- Please replace 26060 with the TCP port number you want to listen.

## How to stop and remove the running container

```shell
$ docker stop server-brook
...
$ docker rm server-brook
...
```
