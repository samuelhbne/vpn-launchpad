FROM alpine:3.10 as builder

RUN apk add --no-cache bash curl bind-tools whois dnscrypt-proxy go autoconf automake build-base git
RUN cd /root && git clone https://github.com/jech/polipo && cd polipo && make
RUN GOPATH=/go go get github.com/txthinking/brook/cli/brook

FROM alpine:3.10

RUN apk update
RUN apk add bash curl bind-tools whois dnscrypt-proxy
RUN rm -rf /var/cache/apk/*

COPY --from=builder /go/bin /go/bin
COPY --from=builder /root/polipo /root/polipo

ADD run.sh /run.sh
RUN chmod 755 /*.sh

ENV LSTNADDR="0.0.0.0"
ENV SOCKSPORT="1080"
ENV HTTPPORT="8123"
ENV DNSPORT="53"

RUN sed -i "s/^listen_addresses = .*/listen_addresses = \[\'0.0.0.0:$DNSPORT\'\]/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml
RUN sed -i "s/^dnscrypt_servers = .*/dnscrypt_servers = false/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml
RUN sed -i "s/^doh_servers = .*/doh_servers = true/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml

RUN echo "socksParentProxy=localhost:$SOCKSPORT" >>/root/polipo/config
RUN echo "proxyAddress=$LSTNADDR" >>/root/polipo/config
RUN echo "proxyPort=$HTTPPORT" >>/root/polipo/config
RUN echo "daemonise=true" >>/root/polipo/config
RUN echo "diskCacheRoot=" >>/root/polipo/config

ENTRYPOINT ["/run.sh"]
