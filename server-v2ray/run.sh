#!/bin/bash

usage() { echo "Usage: $0 [-p <port numbert>] [-u <client uuid>]" 1>&2; exit 1; }
while getopts ":a:l:p:u:" o; do
	case "${o}" in
		a)
			ALTERID=${OPTARG}
			;;
		l)
			LEVEL=${OPTARG}
			;;
		p)
			PORT=${OPTARG}
			;;
		u)
			UUID=${OPTARG}
			;;
		*)
		       	usage;
	esac
done

if [ -z "${PORT}" ] || [ -z "{$UUID}" ]; then
	usage
fi
shift $((OPTIND-1))

cd /etc/v2ray/
cp -a /usr/bin/v2ray/vpoint_vmess_freedom.json vvf.json
jq "(.inbounds[] | select( .protocol == \"vmess\") | .port) |= \"$PORT\"" vvf.json >vvf.json.1
jq "(.inbounds[] | select( .protocol == \"vmess\") | .settings.clients[0].id) |= \"$UUID\"" vvf.json.1 >vvf.json.2
jq "(.inbounds[] | select( .protocol == \"vmess\") | .settings.clients[0].level) |= \"$LEVEL\"" vvf.json.2 >vvf.json.3
jq "(.inbounds[] | select( .protocol == \"vmess\") | .settings.clients[0].alterId) |= \"$ALTERID\"" vvf.json.3 >server.json
exec /usr/bin/v2ray/v2ray -config=/etc/v2ray/server.json
