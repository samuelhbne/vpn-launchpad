#!/bin/bash

usage() {
	echo "server-sslibev -w|--password <password> [-p|--port <port-number>] [-m|--method <encrypt-method>] [-t|--timeout <timeout-seconds>] [-k|--hook <hook-url>]"
	echo "    -w|--password <password>          Password for sslibev server access"
	echo "    -p|--port <port-num>              [Optional] Port number for sslibev server connection, default 8388"
    echo "    -m|--method <encrypt-method>      [Optional] Encrypt method used by sslibev server, default aes-256-gcm"
	echo "    -t|--timeout <timeout-seconds>    [Optional] Connection timeout in seconds, default 300"
	echo "    -k|--hook <hook-url>              [Optional] URL to be hit before server execution, for DDNS update or notification"
}

TEMP=`getopt -o w:p:m:t:k: --long password:,port:method:timeout:hook: -n "$0" -- $@`
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
        -m|--method)
            METHOD="$2"
            shift 2
            ;;
        -t|--timeout)
            TIMEOUT="$2"
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
	PORT=8388
fi

if [ -z "${METHOD}" ]; then
	METHOD="aes-256-gcm"
fi

if [ -z "${TIMEOUT}" ]; then
	TIMEOUT=300
fi

if [ -n "${HOOKURL}" ]; then
	curl -sSL "${HOOKURL}"
	echo
fi

exec /usr/bin/ss-server -p ${PORT} -k ${PASSWORD} -m ${METHOD} -t ${TIMEOUT} -s 0.0.0.0 -s ::0 --fast-open -d 8.8.8.8,8.8.4.4 -u
