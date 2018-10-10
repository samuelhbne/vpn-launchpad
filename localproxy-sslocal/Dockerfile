FROM arm32v6/alpine

ENV SOCKSADDR="0.0.0.0"
ENV SOCKSPORT="51080"
ENV HTTPPORT="58123"
ENV DNSPORT="55353"

RUN apk update && apk add git openssh gcc musl-dev libffi-dev openssl-dev make bash texinfo curl bind-tools py3-pip dnscrypt-proxy

RUN sed -i "s/^listen_addresses = .*/listen_addresses = \[\'0.0.0.0:$DNSPORT\'\]/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml
RUN sed -i "s/^dnscrypt_servers = .*/dnscrypt_servers = false/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml
RUN sed -i "s/^doh_servers = .*/doh_servers = true/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml

RUN pip3 install shadowsocks==2.8.2

RUN cd /root && git clone https://github.com/jech/polipo && cd polipo && make
RUN echo "socksParentProxy=localhost:$SOCKSPORT" >>/root/polipo/config
RUN echo "proxyAddress=$SOCKSADDR" >>/root/polipo/config
RUN echo "proxyPort=$HTTPPORT" >>/root/polipo/config
RUN echo "daemonise=true" >>/root/polipo/config
RUN echo "diskCacheRoot=" >>/root/polipo/config

ADD run.sh /run.sh
RUN chmod 755 /*.sh

EXPOSE 51080 55353 58123
ENTRYPOINT ["/run.sh"]
