#!/bin/bash

usage() { echo "Usage: $0 [-d <trojan domain>] [-p <port number>] [-w <password>]" 1>&2; exit 1; }
while getopts ":d:h:p:w:" o; do
	case "${o}" in
		d)
			DOMAIN=${OPTARG}
			;;
		h)	HOST=${OPTARG}
			;;
		p)
			PORT=${OPTARG}
			;;
		w)
			PASSWORD=${OPTARG}
			;;
		*)
			usage;
	esac
done
if [ -z "${DOMAIN}" ] || [ -z "${PORT}" ] || [ -z "${PASSWORD}" ]; then
	usage
fi

shift $((OPTIND-1))

cat /trojan/examples/client.json-example  \
	| jq " .\"local_addr\" |= \"0.0.0.0\" " \
	| jq " .\"local_port\" |= 1080 " \
	| jq " .\"remote_addr\" |= \"$DOMAIN\" " \
	| jq " .\"remote_port\" |= \"$PORT\" " \
	| jq " .\"password\"[0] |= \"$PASSWORD\" " \
	>/config/client.json

/usr/bin/nohup /trojan/trojan /config/client.json &
/root/polipo/polipo -c /root/polipo/config
exec /usr/bin/dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml
