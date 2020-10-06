#!/bin/bash

usage() {
	echo "proxy-brook -s|--host <brook-server> -w|--password <password> [-p|--port <port-number>]"
	echo "    -s|--server <brook-server>    brook server name or address"
	echo "    -w|--password <password>      Password for brook server access"
	echo "    -p|--port <port-num>          [Optional] Port number for brook server connection, default 6060"
}

TEMP=`getopt -o s:w:p: --long server:,password:,port: -n "$0" -- $@`
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
	PORT=6060
fi

/usr/bin/nohup /go/bin/brook client --socks5 0.0.0.0:1080 -s ${SERVER}:${PORT} -p ${PASSWORD} &
/root/polipo/polipo -c /root/polipo/config
exec /usr/bin/dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml
