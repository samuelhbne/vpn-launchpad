#!/bin/bash

/usr/bin/ss-local -f /var/run/ss-local.pid "$@"
/root/polipo/polipo -c /root/polipo/config
exec /usr/bin/dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml
