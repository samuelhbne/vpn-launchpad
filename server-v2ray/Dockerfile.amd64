FROM alpine:3.10

RUN apk add bash git build-base go musl-dev openssl jq ca-certificates && update-ca-certificates

RUN mkdir /etc/v2ray/
RUN mkdir /var/log/v2ray/
RUN mkdir -p /usr/bin/v2ray/
RUN GOPATH=/go go get -u v2ray.com/core/...
RUN GOPATH=/go go build -o /usr/bin/v2ray/v2ray v2ray.com/core/main
RUN GOPATH=/go go build -o /usr/bin/v2ray/v2ctl v2ray.com/core/infra/control/main
RUN cp -r /go/src/v2ray.com/core/release/config/* /usr/bin/v2ray/

ADD run.sh /run.sh
RUN chmod 755 /*.sh

USER nobody

ENTRYPOINT ["/run.sh"]
