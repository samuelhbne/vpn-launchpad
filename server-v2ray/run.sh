#!/bin/bash

usage() { echo "Usage: $0 [-p <port numbert>] [-u <client uuid>]" 1>&2; exit 1; }
while getopts ":a:p:u:v:" o; do
	case "${o}" in
		a)
			ALTERID="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		v)
			LEVEL="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		p)
			PORT="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		u)
			UUID="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		*)
		       	usage;
	esac
done
shift $((OPTIND-1))

if [ -z "${PORT}" ] || [ -z "${UUID}" ] || [ -z "${ALTERID}" ] || [ -z "${LEVEL}" ]; then
	usage
fi

cd /tmp
cp /usr/bin/v2ray/vpoint_vmess_freedom.json vvf.json
jq "(.inbounds[] | select( .protocol == \"vmess\") | .port) |= \"${PORT}\"" vvf.json >vvf.json.1
jq "(.inbounds[] | select( .protocol == \"vmess\") | .settings.clients[0].id) |= \"${UUID}\"" vvf.json.1 >vvf.json.2
jq "(.inbounds[] | select( .protocol == \"vmess\") | .settings.clients[0].level) |= ${LEVEL}" vvf.json.2 >vvf.json.3
jq "(.inbounds[] | select( .protocol == \"vmess\") | .settings.clients[0].alterId) |= ${ALTERID}" vvf.json.3 >server.json
exec /usr/bin/v2ray/v2ray -config=/tmp/server.json
