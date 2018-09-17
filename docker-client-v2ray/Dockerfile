FROM ubuntu:18.04

ARG CURL_PROXY
ENV DEBIAN_FRONTEND=noninteractive
ENV LISTENADDR=0.0.0.0
ENV HTTPPORT=58123
ENV DNSVRPORT=55353
ENV SOCKSPORT=51080

RUN apt-get update && apt-get install -y curl git build-essential polipo
RUN cd /opt && git clone https://github.com/JustinHop/dns-socks-proxy && cd dns-socks-proxy && make
RUN sed -i "s/socks_port = 5000/socks_port = $SOCKSPORT/g" /opt/dns-socks-proxy/dns_proxy.conf
RUN sed -i "s/listen_addr = 127.0.1.10/listen_addr = $LISTENADDR/g" /opt/dns-socks-proxy/dns_proxy.conf
RUN sed -i "s/listen_port = 53/listen_port = $DNSVRPORT/g" /opt/dns-socks-proxy/dns_proxy.conf
RUN sed -i "s/set_user = dnsproxy/set_user = nobody/g" /opt/dns-socks-proxy/dns_proxy.conf
RUN sed -i "s/set_group = dnsproxy/set_group = nogroup/g" /opt/dns-socks-proxy/dns_proxy.conf
RUN sed -i "s/log_file = \/dev\/stderr/log_file = \/dev\/null/g" /opt/dns-socks-proxy/dns_proxy.conf
RUN echo "8.8.8.8\n8.8.4.4" > /opt/dns-socks-proxy/resolv.conf

RUN /usr/bin/curl -L -s https://install.direct/go.sh -p ${CURL_PROXY} | /bin/bash
#RUN /usr/bin/curl -L -s https://install.direct/go.sh | /bin/bash

RUN echo "socksParentProxy=localhost:$SOCKSPORT" >>/etc/polipo/config
RUN echo "proxyAddress=$LISTENADDR" >>/etc/polipo/config
RUN echo "proxyPort=$HTTPPORT" >>/etc/polipo/config
RUN echo "daemonise=true" >>/etc/polipo/config
RUN echo "diskCacheRoot=" >>/etc/polipo/config

ADD client.json /etc/v2ray/client.json
ADD run.sh /run.sh
RUN chmod 755 /*.sh

EXPOSE 51080 55353 58123
CMD ["/run.sh"]
