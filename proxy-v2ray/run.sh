#!/bin/bash

usage() { echo "Usage: $0 [-h <v2ray hostname/address] [-p <port numbert>] [-u <client uuid>]" 1>&2; exit 1; }
while getopts ":a:k:l:h:p:s:u:v:" o; do
	case "${o}" in
		a)
			ALTERID=${OPTARG}
			;;
		k)	SOCKSPORT=${OPTARG}
			;;
		l)
			LSTNADDR=${OPTARG}
			;;
		h)
			HOST=${OPTARG}
			;;
		p)
			PORT=${OPTARG}
			;;
		s)
			SECURITY=${OPTARG}
			;;
		u)
			UUID=${OPTARG}
			;;
		v)
			LEVEL=${OPTARG}
			;;
		*)
			usage;
	esac
done
if [ -z "${HOST}" ] || [ -z "${PORT}" ] || [ -z "${UUID}" ] || [ -z "${ALTERID}" ] || [ -z "${LEVEL}" ] || [ -z "${SECURITY}" ]; then
	usage
fi

if [ -z "${LSTNADDR}" ]; then
	LSTNADDR="0.0.0.0"
fi

if [ -z "${SOCKSPORT}" ]; then
	SOCKSPORT=1080
fi

shift $((OPTIND-1))

cd /etc/v2ray/
cp -a /usr/bin/v2ray/vpoint_socks_vmess.json vsv.json
jq "(.inbounds[] | select( .protocol == \"socks\") | .listen) |= \"$LSTNADDR\"" vsv.json >vsv.json.1
jq "(.inbounds[] | select( .protocol == \"socks\") | .port) |= \"$SOCKSPORT\"" vsv.json.1 >vsv.json.2
jq "(.inbounds[] | select( .protocol == \"socks\") | .settings.ip) |= \"0.0.0.0\"" vsv.json.2>vsv.json.3
jq "(.outbounds[] | select( .protocol == \"freedom\") | .protocol) |= \"vmess\"" vsv.json.3>vsv.json.4
jq ".outbounds[0].settings |= . + { \"vnext\": [{\"address\": \"$HOST\", \"port\": $PORT, \"users\": [{\"id\": \"$UUID\", \"alterId\": $ALTERID, \"security\": \"$SECURITY\", \"level\": $LEVEL}]}] }" vsv.json.4>client.json

/usr/bin/nohup /usr/bin/v2ray/v2ray -config=/etc/v2ray/client.json &
/root/polipo/polipo -c /root/polipo/config
exec /usr/bin/dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml
