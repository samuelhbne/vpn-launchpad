FROM arm32v6/python:3-alpine

ENV SOCKSADDR="0.0.0.0"
ENV SOCKSPORT="51080"
ENV HTTPPORT="58123"
ENV DNSPORT="55353"

RUN apk update && apk add git openssh gcc musl-dev libffi-dev openssl-dev make bash texinfo curl bind-tools py-pip
RUN cd /root && git clone https://github.com/jtripper/dns-tcp-socks-proxy
RUN sed -i "s/socks_port = 5000/socks_port = $SOCKSPORT/g" /root/dns-tcp-socks-proxy/dns_proxy.conf
RUN sed -i "s/listen_addr = 127.0.1.10/listen_addr = $SOCKSADDR/g" /root/dns-tcp-socks-proxy/dns_proxy.conf
RUN sed -i "s/listen_port = 53/listen_port = $DNSPORT/g" /root/dns-tcp-socks-proxy/dns_proxy.conf
RUN sed -i "s/set_user = dnsproxy/set_user = nobody/g" /root/dns-tcp-socks-proxy/dns_proxy.conf
RUN sed -i "s/set_group = dnsproxy/set_group = nogroup/g" /root/dns-tcp-socks-proxy/dns_proxy.conf
RUN sed -i "s/log_file = \/dev\/stderr/log_file = \/dev\/null/g" /root/dns-tcp-socks-proxy/dns_proxy.conf
RUN echo -e "8.8.8.8\n8.8.4.4" > /root/dns-tcp-socks-proxy/resolv.conf
RUN sed -i '140s/ ns/ strtok \(ns, \"\\n\"\)' /root/dns-tcp-socks-proxy/dns_proxy.c
RUN cd /root/dns-tcp-socks-proxy && make

RUN pip install shadowsocks==2.8.2

RUN cd /root && git clone https://github.com/jech/polipo && cd polipo && make
RUN echo "socksParentProxy=localhost:$SOCKSPORT" >>/root/polipo/config
RUN echo "proxyAddress=$SOCKSADDR" >>/root/polipo/config
RUN echo "proxyPort=$HTTPPORT" >>/root/polipo/config
RUN echo "daemonise=true" >>/root/polipo/config
RUN echo "diskCacheRoot=" >>/root/polipo/config

ADD run.sh.rspi /run.sh
RUN chmod 755 /*.sh

EXPOSE 51080 55353 58123
ENTRYPOINT ["/run.sh"]
