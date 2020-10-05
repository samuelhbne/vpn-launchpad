#!/bin/bash

usage() {
	echo "server-trojan -d|--domain <domain-name> -w|--password <password> [-p|--port <port-num>] [-f|--fake <fake-domain>] [-k|--hook <hook-url>]"
	echo "    -d|--domain <domain-name> Trojan server domain name"
	echo "    -w|--password <password>  Password for Trojan service access"
	echo "    -p|--port <port-num>      [Optional] Port number for incoming Trojan connection"
	echo "    -f|--fake <fake-domain>   [Optional] Fake domain name when access Trojan without correct password"
	echo "    -k|--hook <hook-url>      [Optional] URL to be hit before server execution, for DDNS update or notification"
}

TEMP=`getopt -o d:w:p:f:k: --long domain:,password:,port:,fake:hook: -n "$0" -- $@`
if [ $? != 0 ] ; then usage; exit 1 ; fi

eval set -- "$TEMP"
while true ; do
	case "$1" in
		-d|--domain)
			DOMAIN="$2"
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
		-f|--fake)
			FAKEDOMAIN="$2"
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

if [ -z "${PASSWORD}" ] || [ -z "${DOMAIN}" ]; then
	usage
	exit 2
fi

if [ -z "${FAKEDOMAIN}" ]; then
	FAKEDOMAIN="www.microsoft.com"
fi

if [ -z "${PORT}" ]; then
	PORT=443
fi

if [ -n "${HOOKURL}" ]; then
	curl -sSL "${HOOKURL}"
	echo
fi

TRY=0
while [ ! -f "/root/.acme.sh/${DOMAIN}/fullchain.cer" ]
do
	/root/.acme.sh/acme.sh --issue --standalone -d ${DOMAIN}
	((TRY++))
	if [ $TRY >= 3 ]; then
		echo "Obtian cert for ${DOMAIN} failed. Check log please."
		exit 3
	fi
done

cat /trojan/examples/server.json-example  \
	| jq " .\"local_port\" |= ${PORT} " \
	| jq " .\"remote_addr\" |= \"${FAKEDOMAIN}\" " \
	| jq " .\"password\"[0] |= \"${PASSWORD}\" " \
	| jq " .\"ssl\".\"cert\" |= \"/root/.acme.sh/${DOMAIN}/fullchain.cer\" " \
	| jq " .\"ssl\".\"key\" |= \"/root/.acme.sh/${DOMAIN}/${DOMAIN}.key\" " \
	>/config/server.json

exec /trojan/trojan /config/server.json
