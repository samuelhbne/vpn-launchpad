# server-brook
Yet another unofficial [Brook](https://github.com/txthinking/brook) server installation scripts.

### How to build the image
```
$ docker build -t samuelhbne/server-brook:amd64 -f Dockerfile.amd64 .
```
### How to start the container
```
$ docker run --restart unless-stopped --name server-brook -p ${BROOK_PORT}:6060 -d samuelhbne/server-brook:amd64 server -l :6060 -p ${BROOK_PASS}
```

### How to stop and remove the running container
```
$ docker stop server-brook
$ docker rm server-brook
```

### Standalone server deployment
```
$ cat server-brook.env
BRKPORT="6060"
BRKPASS="BROOK_PASS"
$ ./server-brook.sh
```
