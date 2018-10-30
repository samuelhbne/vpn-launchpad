FROM alpine

RUN apk update && apk add py3-pip
RUN pip3 install shadowsocks==2.8.2

ENTRYPOINT ["/usr/bin/ssserver"]
