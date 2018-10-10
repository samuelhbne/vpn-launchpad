#!/bin/bash

DNSPORT="55353"
DOHSVR="cloudflare-dns.com"

doh-stub --listen-port $DNSPORT --listen-address 0.0.0.0 --remote-address $DOHSVR --domain $DOHSVR &
#cd /root/dns-tcp-socks-proxy && /root/dns-tcp-socks-proxy/dns_proxy
/root/polipo/polipo -c /root/polipo/config
exec /usr/bin/sslocal "$@"
