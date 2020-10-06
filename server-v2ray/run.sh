#!/bin/bash

usage() {
	echo "server-v2ray -u|--uuid <vmess-uuid> [-p|--port <port-num>] [-l|--level <level>] [-a|--alterid <alterid>] [-k|--hook hook-url]"
	echo "    -u|--uuid <vmess-uuid>    Vmess UUID for initial V2ray connection"
	echo "    -p|--port <port-num>      [Optional] Port number for incoming V2ray connection, default 10086"
	echo "    -l|--level <level>        [Optional] Level number for V2ray service access, default 0"
	echo "    -a|--alterid <alterid>    [Optional] AlterID number for V2ray service access, default 16"
	echo "    -k|--hook <hook-url>      [Optional] URL to be hit before server execution, for DDNS update or notification"
}

TEMP=`getopt -o u:p:l:a: --long uuid:,port:,level:,alterid: -n "$0" -- $@`
if [ $? != 0 ] ; then usage; exit 1 ; fi

eval set -- "$TEMP"
while true ; do
	case "$1" in
		-u|--uuid)
			UUID="$2"
			shift 2
			;;
		-p|--port)
			PORT="$2"
			shift 2
			;;
		-l|--level)
			LEVEL="$2"
			shift 2
			;;
		-a|--alterid)
			ALTERID="$2"
			shift 2
			;;
		--)
			shift
			break
			;;
		*)
			usage;
			exit 1
			;;
	esac
done

if [ -z "${UUID}" ]; then
	usage
	exit 1
fi

if [ -z "${PORT}" ]; then
	PORT=10086
fi

if [ -z "${ALTERID}" ]; then
	ALTERID=16
fi

if [ -z "${LEVEL}" ]; then
	LEVEL=0
fi

if [ -n "${HOOKURL}" ]; then
	curl -sSL "${HOOKURL}"
	echo
fi

cd /tmp
cp /usr/bin/v2ray/vpoint_vmess_freedom.json vvf.json
jq "(.inbounds[] | select( .protocol == \"vmess\") | .port) |= \"${PORT}\"" vvf.json >vvf.json.1
jq "(.inbounds[] | select( .protocol == \"vmess\") | .settings.clients[0].id) |= \"${UUID}\"" vvf.json.1 >vvf.json.2
jq "(.inbounds[] | select( .protocol == \"vmess\") | .settings.clients[0].level) |= ${LEVEL}" vvf.json.2 >vvf.json.3
jq "(.inbounds[] | select( .protocol == \"vmess\") | .settings.clients[0].alterId) |= ${ALTERID}" vvf.json.3 >server.json
exec /usr/bin/v2ray/v2ray -config=/tmp/server.json
