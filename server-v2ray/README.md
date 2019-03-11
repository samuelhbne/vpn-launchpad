# server-v2ray
Yet another unofficial [v2ray](https://github.com/v2ray) server implementation.

# How to use
```
$ docker build -t samuelhbne/server-v2ray:amd64 -f Dockerfile.amd64 .
docker run --restart unless-stopped --name server-v2ray -p ${V2RAY_PORT}:10086 -d samuelhbne/server-v2ray:amd64 -p 10086 -u ${V2RAY_UUID} -v ${V2RAY_LEVEL} -a ${V2RAY_ALTERID}

```
