# server-v2ray
Yet another unofficial [v2ray](https://github.com/v2ray) server installation scripts.

### How to build the image
```
$ docker build -t samuelhbne/server-v2ray:amd64 -f Dockerfile.amd64 .
```

### How to start the container
```
$ docker run --restart unless-stopped --name server-v2ray -p ${V2RAY_PORT}:10086 -d samuelhbne/server-v2ray:amd64 -p 10086 -u ${V2RAY_UUID} -v ${V2RAY_LEVEL} -a ${V2RAY_ALTERID}

```

### How to stop and remove the running container
```
$ docker stop server-v2ray
$ docker rm server-v2ray
```

### Standalone server deployment
Instructions below run server-v2ray on any server with docker installed.
```
$ cat server-v2ray.env
V2RAYUUID="e6daf07f-15f1-4785-8a7f-7aeeae446bdb"
V2RAYPORT="10086"
V2RAYLEVEL="1"
V2RAYAID="64"
$ ./server-v2ray.sh
```

