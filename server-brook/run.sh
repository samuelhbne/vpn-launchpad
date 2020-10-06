#!/bin/bash

usage() {
	echo "server-brook -w|--password <password> [-p|--port <port-number>]"
	echo "    -w|--password <password>      Password for brook server access"
	echo "    -p|--port <port-num>          [Optional] Port number for brook server connection, default 6060"
	echo "    -k|--hook <hook-url>          [Optional] URL to be hit before server execution, for DDNS update or notification"
}

TEMP=`getopt -o w:p:k: --long password:,port:hook: -n "$0" -- $@`
if [ $? != 0 ] ; then usage; exit 1 ; fi

eval set -- "$TEMP"
while true ; do
	case "$1" in
		-w|--password)
			PASSWORD="$2"
			shift 2
			;;
		-p|--port)
			PORT="$2"
			shift 2
			;;
		-k|--hook)
			HOOKURL="$2"
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

if [ -z "${PASSWORD}" ]; then
	usage
	exit 1
fi

if [ -z "${PORT}" ]; then
	PORT=6060
fi

if [ -n "${HOOKURL}" ]; then
	curl -sSL "${HOOKURL}"
	echo
fi

exec /go/bin/brook server -l :${PORT} -p ${PASSWORD}
