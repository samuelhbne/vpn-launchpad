# server-v2ray
Yet another unofficial [v2ray](https://github.com/v2ray) server implementation.

# How to use

V2RAYPORT:	Vmess service port
V2RAYUUID:	Vmess config uuid 
V2RAYLEVEL:	Vmess config level
V2RAYALTERID:	Vmess config alterId

```
$ docker build -t samuelhbne/server-v2ray:amd64 -f Dockerfile.amd64 .
docker run --restart unless-stopped --name server-v2ray -p ${V2RAYPORT}:10086 -d samuelhbne/server-v2ray:amd64 -p 10086 -u ${V2RAYUUID} -v ${V2RAYLEVEL} -a ${V2RAYALTERID}

```
