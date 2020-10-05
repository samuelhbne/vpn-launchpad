#!/bin/bash

usage() {
	echo "proxy-sslibev -s|--host <sslibev-server> -w|--password <password> [-p|--port <port-number>] [-m|--method <encrypt-method>] [-t|--timeout <timeout-seconds>]"
	echo "    -s|--server <sslibev-server>      sslibev server name or address"
	echo "    -w|--password <password>          Password for sslibev server access"
	echo "    -p|--port <port-num>              [Optional] Port number for sslibev server connection, default 8388"
    echo "    -m|--method <encrypt-method>      [Optional] Encrypt method used by sslibev server, default aes-256-gcm"
	echo "    -t|--timeout <timeout-seconds>    [Optional] Connection timeout in seconds"
}

TEMP=`getopt -o s:w:p:m:t: --long server:,password:,port:method:timeout: -n "$0" -- $@`
if [ $? != 0 ] ; then usage; exit 1 ; fi

eval set -- "$TEMP"
while true ; do
	case "$1" in
		-s|--server)
			SERVER="$2"
			shift 2
			;;
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

if [ -z "${SERVER}" ] || [ -z "${PASSWORD}" ]; then
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

/usr/bin/ss-local -f /var/run/ss-local.pid -s ${SERVER} -p ${PORT} -k ${PASSWORD} -m ${METHOD} -t ${TIMEOUT} -l 1080 -b 0.0.0.0
/root/polipo/polipo -c /root/polipo/config
exec /usr/bin/dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml
