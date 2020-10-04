#!/bin/bash

usage() {
	echo "proxy-trojan -d|--domain <trojan-domain> -w|--password <password> [-p|--port <port-number>]"
	echo "    -d|--domain <trojan-domain>   Trojan server domain name"
	echo "    -w|--password <password>      Password for Trojan server access"
	echo "    -p|--port <port-num>          [optional] Port number for Trojan server connection"
}

TEMP=`getopt -o h:w:p: --long host:,password:,port: -n "$0" -- $@`
if [ $? != 0 ] ; then usage; exit 1 ; fi

eval set -- "$TEMP"
while true ; do
	case "$1" in
		-d|--domain)
			TJDOMAIN="$2"
			shift 2
			;;
		-w|--password)
			PASSWORD="$2"
			shift 2
			;;
		-p|--port)
			TJPORT="$2"
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

if [ -z "${TJDOMAIN}" ] || [ -z "${PASSWORD}" ]; then
	usage
	exit 1
fi

if [ -z "${TJPORT}" ]; then
	TJPORT=443
fi

shift $((OPTIND-1))

cat /trojan/examples/client.json-example  \
	| jq " .\"local_addr\" |= \"0.0.0.0\" " \
	| jq " .\"local_port\" |= 1080 " \
	| jq " .\"remote_addr\" |= \"${TJDOMAIN}\" " \
	| jq " .\"remote_port\" |= \"${TJPORT}\" " \
	| jq " .\"password\"[0] |= \"${PASSWORD}\" " \
	>/config/client.json

/usr/bin/nohup /trojan/trojan /config/client.json &
/root/polipo/polipo -c /root/polipo/config
exec /usr/bin/dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml
