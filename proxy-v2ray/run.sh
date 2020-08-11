#!/bin/bash

usage() { echo "Usage: $0 -h <v2ray-host> -u <uuid> [-p <port-numbert>] [-a <alterid>] [-l <level>] [-s <security>]" 1>&2; exit 1; }

while getopts ":a:l:h:p:s:u:" o; do
	case "${o}" in
		a)
			ALTERID="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		l)
			LEVEL="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		h)
			VHOST="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		p)
			VPORT="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		s)
			SECURITY="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		u)
			UUID="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		*)
			usage;
	esac
done

if [ -z "${VHOST}" ] || [ -z "${UUID}" ]; then
	usage
	exit 2
fi

if [ -z "${VPORT}" ]; then
	VPORT=10086
fi

if [ -z "${ALTERID}" ]; then
	ALTERID=16
fi

if [ -z "${LEVEL}" ]; then
	LEVEL=0
fi

if [ -z "${SECURITY}" ]; then
	SECURITY="auto"
fi

shift $((OPTIND-1))

LSTNADDR="0.0.0.0"
SOCKSPORT=1080

cd /tmp
cp -a /usr/bin/v2ray/vpoint_socks_vmess.json vsv.json
jq "(.inbounds[] | select( .protocol == \"socks\") | .listen) |= \"${LSTNADDR}\"" vsv.json >vsv.json.1
jq "(.inbounds[] | select( .protocol == \"socks\") | .port) |= \"${SOCKSPORT}\"" vsv.json.1 >vsv.json.2
jq "(.inbounds[] | select( .protocol == \"socks\") | .settings.ip) |= \"0.0.0.0\"" vsv.json.2>vsv.json.3
jq "(.outbounds[] | select( .protocol == \"freedom\") | .protocol) |= \"vmess\"" vsv.json.3>vsv.json.4
jq ".outbounds[0].settings |= . + { \"vnext\": [{\"address\": \"${VHOST}\", \"port\": ${VPORT}, \"users\": [{\"id\": \"${UUID}\", \"alterId\": ${ALTERID}, \"security\": \"${SECURITY}\", \"level\": ${LEVEL}}]}] }" vsv.json.4>client.json

/usr/bin/nohup /usr/bin/v2ray/v2ray -config=/tmp/client.json &
/root/polipo/polipo -c /root/polipo/config
exec /usr/bin/dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml

