#!/bin/bash

/etc/init.d/polipo restart
cd /opt/dns-socks-proxy && ./dns_proxy
exec /usr/bin/v2ray/v2ray -config /etc/v2ray/client.json
