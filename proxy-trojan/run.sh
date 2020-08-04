#!/bin/bash

usage() { echo "Usage: $0 -h <trojan-host> -w <password> [-p <port-number>]" 1>&2; exit 1; }

while getopts ":d:h:p:w:" o; do
	case "${o}" in
		h)
			TJHOST="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		p)
			TJPORT="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		w)
			PASSWORD="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		*)
			usage;
	esac
done

if [ -z "${TJHOST}" ] || [ -z "${PASSWORD}" ]; then
	usage
fi

if [ -z "${TJPORT}" ]; then
	TJPORT=443
fi

shift $((OPTIND-1))

cat /trojan/examples/client.json-example  \
	| jq " .\"local_addr\" |= \"0.0.0.0\" " \
	| jq " .\"local_port\" |= 1080 " \
	| jq " .\"remote_addr\" |= \"${TJHOST}\" " \
	| jq " .\"remote_port\" |= \"${TJPORT}\" " \
	| jq " .\"password\"[0] |= \"${PASSWORD}\" " \
	>/config/client.json

/usr/bin/nohup /trojan/trojan /config/client.json &
/root/polipo/polipo -c /root/polipo/config
exec /usr/bin/dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml
