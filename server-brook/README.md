# server-brook
Yet another unofficial [Brook](https://github.com/txthinking/brook) server implementation.

# How to use
```
$ docker build -t samuelhbne/server-brook:amd64 -f Dockerfile.amd64 .
$ docker run --restart unless-stopped --name server-brook -p ${BROOK_PORT}:6060 -d samuelhbne/server-brook:amd64 server -l :6060 -p ${BROOK_PASS}
```
