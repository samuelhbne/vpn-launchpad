# server-trojan

Yet another unofficial [Trojan](https://github.com/trojan-gfw/trojan) server installation scripts.

## How to build server-trojan docker image

```shell
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad/server-trojan
$ docker build -t samuelhbne/server-trojan:amd64 -f Dockerfile.amd64 .
...
```

## How to start server-trojan container manually

The following instructions will:

- Update the IP address of your duckdns dynamic domain name.
- Request TLS cert from letsencrypt.org
- Start server-trojan container

```shell
$ get -qO- "https://duckdns.org/update/my-domain/0f8d8cb0-fec5-4339-8026-ca051cc0ce4a"

$ docker run \
  --name=letsencrypt \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e URL="my-domain.duckdns.org" \
  -e SUBDOMAINS=wildcard, \
  -e VALIDATION=duckdns \
  -e DUCKDNSTOKEN=0f8d8cb0-fec5-4339-8026-ca051cc0ce4a \
  -e STAGING=false \
  -p 8443:443 \
  -p 8080:80 \
  -v `pwd`/config:/config \
  -d linuxserver/letsencrypt

$ sleep 300

$ docker logs letsencrypt

$ docker run --rm -it samuelhbne/server-trojan:amd64
Usage: /run.sh -d <duckdns-domain-name> -t <duckdns-token> -w <password> [-f <fake-domain-name>]

$ docker run --name server-trojan -v `pwd`/config:/config -p 443:443 -d samuelhbne/server-trojan:amd64 -d my-domain -w my-secret -t 0f8d8cb0-fec5-4339-8026-ca051cc0ce4a
...
```

### NOTE1

- Please register your free domain name on [https://duckdns.org](https://duckdns.org) and get your token there subsequently.
- Please replace "my-domain", "my-secret" and duckdns token above with yours accordingly.
- Before starting server-trojan, please check letsencrypt log to confirm if TLS cert has been obtained correctly.
- You may reach the limitation of 10 times renewal a day applied by Letsencrypt soon if you start letsencrypt container too frequent.

## Start Trojan server with help script (Recommended)

```shell
$ cat server-trojan.env
SGTCP="443"
TRJPORT="443"
TRJPASS="my-secret"
TRJFAKEDOMAIN="www.microsoft.com"
DUCKDNSTOKEN="0f8d8cb0-fec5-4339-8026-ca051cc0ce4a"
DUCKDNSDOMAIN="my-domain"
DUCKSUBDOMAINS="wildcard"

$ ./server-trojan.sh
...
```

## How to verify if server-trojan is running properly

Try to connect the server from trojan compatible mobile app like [Igniter](https://github.com/trojan-gfw/igniter) with the domain-name and password set above. Or follow the instructions below.

### Please run the following instructions on an Ubuntu / Debian / Raspbian client host

```shell
$ docker run --rm -it samuelhbne/proxy-trojan:amd64
Usage: /run.sh -h <trojan-host> -w <password> [-p <port-number>]

$ docker run --name proxy-trojan -p 1080:1080 -p 65353:53/udp -p 8123:8123 -d samuelhbne/proxy-trojan:amd64 -h my-domain.duckdns.org -w my-secret
...

$ curl -sx socks5h://127.0.0.1:1080 http://ifconfig.co
12.34.56.78
```

### NOTE2

- First we ran proxy-trojan as a SOCKS5 proxy that tunneling traffic through your trojan server.
- Then launching curl with client-IP address query through the proxy.
- This query went through your server with server-trojan running.
- You should get the public IP address of your server with server-trojan running if all good.
- Please have a look over the sibling project [proxy-trojan](https://github.com/samuelhbne/vpn-launchpad/tree/master/proxy-trojan) for more details.

## How to stop and remove the running container

```shell
$ docker stop letsencrypt; docker rm letsencrypt
...
$ docker stop server-trojan; docker rm server-trojan
...
```
