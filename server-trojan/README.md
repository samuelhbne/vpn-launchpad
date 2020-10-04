# server-trojan

Yet another unofficial [Trojan](https://github.com/trojan-gfw/trojan) server installation scripts.

## How to build server-trojan docker image

```shell
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad/server-trojan
$ docker build -t samuelhbne/server-trojan:amd64 -f Dockerfile.amd64 .
...
```

### NOTE1

- Please replace Dockerfile.amd64 with the Dockerfile.ARCH match the current server accordingly. For example: Dockerfile.arm64 for AWS ARM64 platform like A1 and t4g instance or 64bit Ubuntu on Raspberry Pi. Dockerfile.arm for 32bit Raspbian.

## How to start server-trojan container

```shell
$ docker run --rm -it samuelhbne/server-trojan:amd64
server-trojan -d|--domain <domain-name> -w|--password <password> [-p|--port port-num] [-f|--fake fake-domain] [-k|--hook hook-url]
    -d|--domain <domain-name> Trojan server domain name
    -w|--password <password>  Password for Trojan service access
    -p|--port <port-num>      [optional] Port number for incoming HTTPS connection
    -f|--fake <fake-domain>   [optional] Fake domain name when access Trojan without correct password
    -k|--hook <hook-url>      [optional] URL to be hit before server execution, for DDNS update or notification
$ docker run --name server-trojan -p 80:80 -p 443:443 -d samuelhbne/server-trojan:amd64 -d my-domain.somedomain.com -w my-secret
...
$
```

### NOTE2

- Please ensure your TCP port 80 (domain name verification) and 443 (Trojan service) are reachable.
- Please replace "<span>my-domain.somedomain.com</span>" and "my-secret" above with your FULL domain-name and Trojan service access password accordingly.
- You can optionally assign a HOOK-URL from command line to update DDNS domain-name pointing to the current server public IP address.
- Alternatively, server-trojan assumes you've ALREADY set the domain-name pointed to the current server public IP address. server-trojan may fail as unable to obtian Letsencrypt cert for the domain-name you set otherwise .
- You may reach the limitation of 10 times renewal a day applied by Letsencrypt soon if you remove and restart server-trojan container too frequent.

## How to verify if server-trojan is running properly

Try to connect the server from trojan compatible mobile app like [Igniter](https://github.com/trojan-gfw/igniter) for Android or [Shadowrocket](https://apps.apple.com/us/app/shadowrocket/id932747118) for iOS with the domain-name and password set above. Or verify it on Ubuntu / Debian / Raspbian client host follow the instructions below.

### Please run the following instructions from Ubuntu / Debian / Raspbian client host for verifying

```shell
$ docker run --rm -it samuelhbne/proxy-trojan:amd64
Usage: /run.sh -h <trojan-host> -w <password> [-p <port-number>]

$ docker run --name proxy-trojan -p 1080:1080 -p 65353:53/udp -p 8123:8123 -d samuelhbne/proxy-trojan:amd64 -h my-domain.duckdns.org -w my-secret
...

$ curl -sSx socks5h://127.0.0.1:1080 http://ifconfig.co
12.34.56.78
```

### NOTE4

- First we ran proxy-trojan as SOCKS5 proxy that tunneling traffic through your trojan server.
- Then launching curl with client-IP address query through the proxy.
- This query was sent through your server with server-trojan running.
- You should get the public IP address of your server with server-trojan running if all good.
- Please have a look over the sibling project [proxy-trojan](https://github.com/samuelhbne/vpn-launchpad/tree/master/proxy-trojan) for more details.

## How to stop and remove the running container

```shell
$ docker stop server-trojan;
...
$ docker rm server-trojan
...
$
```
