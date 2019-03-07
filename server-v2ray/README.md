# server-v2ray
Yet another unofficial [v2ray](https://github.com/v2ray) server implementation.

# How to use
```
$ docker build -t samuelhbne/server-v2ray:amd64 -f Dockerfile.amd64 .
$ docker run --restart unless-stopped --name server-v2ray -p 10086:10086 -d samuelhbne/server-v2ray:amd64 -p 10086 -u 0b5970d7-6cc6-4b7a-a388-026211f0ca10
```
