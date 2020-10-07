# server-sslibev

Yet another unofficial [Shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev) server installation scripts.

## [Optional] How to build server-sslibev docker image

```shell
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad/server-sslibev
$ docker build -t samuelhbne/server-sslibev:amd64 -f Dockerfile.amd64 .
...
```

### NOTE1

- Please replace "amd64" with the arch match the current box accordingly. For example: "arm64" for AWS ARM64 platform like A1, t4g instance or 64bit Ubuntu on Raspberry Pi. "arm" for 32bit Raspbian.

## How to start the container

```shell
$ docker run --rm -it samuelhbne/server-sslibev:amd64
server-sslibev -w|--password <password> [-p|--port <port-number>] [-m|--method <encrypt-method>] [-t|--timeout <timeout-seconds>] [-k|--hook <hook-url>]
    -w|--password <password>          Password for sslibev server access
    -p|--port <port-num>              [Optional] Port number for sslibev server connection, default 8388
    -m|--method <encrypt-method>      [Optional] Encrypt method used by sslibev server, default aes-256-gcm
    -t|--timeout <timeout-seconds>    [Optional] Connection timeout in seconds, default 300
    -k|--hook <hook-url>              [Optional] URL to be hit before server execution, for DDNS update or notification
$ docker run --name server-sslibev -p 28388:8388 -p 28388:8388/udp -d samuelhbne/server-sslibev:amd64 -k my-secret -m aes-256-gcm
...
```

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

### NOTE2

- Please replace "amd64" with the arch match the current box accordingly. For example: "arm64" for AWS ARM64 platform like A1, t4g instance or 64bit Ubuntu on Raspberry Pi. "arm" for 32bit Raspbian.
- Please replace 28388 with the TCP port number you want to listen for sslibev service.
- Please replace "my-secret" with the password you want to set for client auth.
- Please replace "aes-256-gcm" with the encrypt method you want to set.
- You can optionally assign a HOOK-URL to update the DDNS domain-name pointing to the current server public IP address.

## How to verify if server-sslibev is running properly

Try to connect the server from sslibev compatible mobile app like [shadowsocks-android](https://github.com/shadowsocks/shadowsocks-android) for Android or [Shadowrocket](https://apps.apple.com/us/app/shadowrocket/id932747118) for iOS with the host and password set above. Or verify it from Ubuntu / Debian / Raspbian client host follow the instructions below.

### Please run the following instructions from Ubuntu / Debian / Raspbian client host for verifying

```shell
$ docker run --rm -it samuelhbne/proxy-sslibev:amd64
proxy-sslibev -s|--host <sslibev-server> -w|--password <password> [-p|--port <port-number>] [-m|--method <encrypt-method>] [-t|--timeout <timeout-seconds>]
    -s|--server <sslibev-server>      sslibev server name or address
    -w|--password <password>          Password for sslibev server access
    -p|--port <port-num>              [Optional] Port number for sslibev server connection, default 8388
    -m|--method <encrypt-method>      [Optional] Encrypt method used by sslibev server, default aes-256-gcm
    -t|--timeout <timeout-seconds>    [Optional] Connection timeout in seconds
$ docker run --name proxy-sslibev -p 1080:1080 -p 65353:53/udp -p 8123:8123 -d samuelhbne/proxy-sslibev:amd64 -s 12.34.56.78 -p 28388 -w "my-secret"
...
$ curl -sSx socks5h://127.0.0.1:1080 http://ifconfig.co
12.34.56.78
```

### NOTE4

- First we ran proxy-sslibev as SOCKS5 proxy that tunneling traffic through your sslibev server.
- Then launching curl with client-IP address query through the proxy.
- This query was sent through your server with server-sslibev running.
- You should get the public IP address of your server with server-sslibev running if all good.
- Please have a look over the sibling project [proxy-sslibev](https://github.com/samuelhbne/vpn-launchpad/tree/master/proxy-sslibev) for more details.

## How to stop and remove the running container

```shell
$ docker stop server-sslibev
...
$ docker rm server-sslibev
...
```
