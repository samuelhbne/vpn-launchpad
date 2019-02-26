#!/bin/bash

/usr/bin/nohup /go/bin/brook "$@" &
/root/polipo/polipo -c /root/polipo/config
exec /usr/bin/dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml
