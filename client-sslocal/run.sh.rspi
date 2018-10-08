#!/bin/bash

/root/polipo/polipo -c /root/polipo/config
cd /root/dns-tcp-socks-proxy && /root/dns-tcp-socks-proxy/dns_proxy
exec /usr/local/bin/sslocal "$@"
