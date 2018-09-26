#!/bin/bash

/etc/init.d/polipo restart
cd /opt/dns-socks-proxy && ./dns_proxy
exec /usr/local/bin/sslocal "$@"
