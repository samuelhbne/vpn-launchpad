# server-trojan
Yet another unofficial [Trojan](https://github.com/trojan-gfw/trojan) server installation scripts.

### How to build the image
```
$ docker build -t samuelhbne/server-trojan:amd64 -f Dockerfile.amd64 .
```

### Start Trojan server with help script (Recommended)
```
$ cat server-trojan.env
SGTCP="443"
TRJPORT="443"
TRJPASS="my-secret"
TRJFAKEDOMAIN="www.microsoft.com"
DUCKDNSTOKEN="0f8d8cb0-fec5-4339-8026-ca051cc0ce4a"
DUCKDNSDOMAIN="my-domain"
DUCKSUBDOMAINS="wildcard"

$ ./server-trojan.sh
```

### How to start server-trojan container manually

```
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
  -p 443:443 \
  -p 8080:80 \
  -v `pwd`/config:/config \
  -d linuxserver/letsencrypt

$ sleep 300

$ docker logs letsencrypt

$ docker run --restart unless-stopped --name server-trojan -v `pwd`/config:/config -p 443:443 -d samuelhbne/server-trojan:amd64 -p 443 -w my-secret -f www.microsoft.com -t 0f8d8cb0-fec5-4339-8026-ca051cc0ce4a -d my-domain
```
##### NOTE:
    -   Please register your domain name on https://duckdns.org and get your token there subsequently.
    -   Please replace the domain name and duckdns token with yours accordingly.
    -   Please check letsencrypt log before starting server-trojan to confirm if TLS cert has been obtained correctly.
    -   You may reach the limitation of 10 times renewal a day applied by Letsencrypt easily if you start letsencrypt container frequently.

### How to stop and remove the running container
```
$ docker stop letsencrypt; docker rm letsencrypt
$ docker stop server-trojan; docker rm server-trojan
```
