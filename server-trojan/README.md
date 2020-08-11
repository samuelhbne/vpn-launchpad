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

- Please replace Dockerfile.amd64 with the Dockerfile.ARCH match the current server accordingly. For example: Dockerfile.arm for 32bit Raspbian, Dockerfile.arm64 for 64bit Ubuntu for Raspberry Pi.

## How to start server-trojan container manually if you already have a domain name pointed to the current server

```shell
$ docker run --rm -it samuelhbne/server-trojan:amd64
Usage: /run.sh -d <domain-name> -w <password> [-f <fake-domain-name>]

$ docker run --name server-trojan -p 80:80 -p 443:443 -d samuelhbne/server-trojan:amd64 -d my-domain.somedomain.com -w my-secret
...
server-trojan started.
Done
$
```

### NOTE2

- Please ensure your TCP port 80 and 443 are reachable.
- server-trojan assumes you already have a domain name and pointed to the current server. Otherwise server-trojan will fail as unable to obtian Letsencrypt cert for the domain-name you set.
- Please replace "my-domain.somedomain.com" and "my-secret" above with your FULL domain-name and password accordingly.
- You may reach the limitation of 10 times renewal a day applied by Letsencrypt soon if you remove and restart server-trojan container too frequent.

## Start server-trojan via help script with duckdns free domain name (Recommended)

```shell
$ cat server-trojan.env
SGTCP="80:443"
TRJPORT="443"
TRJPASS="my-secret"
TRJFAKEDOMAIN="www.microsoft.com"
DUCKDNSTOKEN="0f8d8cb0-fec5-4339-8026-ca051cc0ce4a"
DUCKDNSDOMAIN="my-domain"
DNSUPDATE=duckdns

$ ./server-trojan.sh
...
server-trojan started.
Done
$
```

### NOTE3

- Please ensure your TCP port 80 and 443 are reachable.
- Please register your free domain name on [duckdns.org](https://duckdns.org) and get your token from duckdns home page after login.
- Please replace DUCKDNSDOMAIN, TRJPASS and DUCKDNSTOKEN settings above with yours accordingly.
- You may reach the limitation of 10 times renewal a day applied by Letsencrypt soon if you remove and restart server-trojan container too frequent.

## How to verify if server-trojan is running properly

Try to connect the server from trojan compatible mobile app like [Igniter](https://github.com/trojan-gfw/igniter) with the full domain-name and password set above. Or verify it on Ubuntu / Debian / Raspbian client host follow the instructions below.

### Please run the following instructions from Ubuntu / Debian / Raspbian client host for verifying

```shell
$ docker run --rm -it samuelhbne/proxy-trojan:amd64
Usage: /run.sh -h <trojan-host> -w <password> [-p <port-number>]

$ docker run --name proxy-trojan -p 1080:1080 -p 65353:53/udp -p 8123:8123 -d samuelhbne/proxy-trojan:amd64 -h my-domain.duckdns.org -w my-secret
...

$ curl -sx socks5h://127.0.0.1:1080 http://ifconfig.co
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
