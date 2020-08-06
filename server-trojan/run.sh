#!/bin/bash

usage() { echo "Usage: $0 -d <duckdns-domain-name> -t <duckdns-token> -w <password> [-f <fake-domain-name>]" 1>&2; exit 1; }
while getopts ":d:f:t:w:" o; do
	case "${o}" in
		d)
			DUCKDOMAIN="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		f)
			FAKEDOMAIN="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		t)
			DUCKTOKEN="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		w)
			PASSWORD="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		*)
		       	usage;
	esac
done

if [ -z "${PASSWORD}" ] || [ -z "${DUCKDOMAIN}" ] || [ -z "${DUCKTOKEN}" ]; then
	usage
	exit 2
fi

if [ -z "${FAKEDOMAIN}" ]; then
	FAKEDOMAIN="www.microsoft.com"
fi

PORT=443

shift $((OPTIND-1))

cat /trojan/examples/server.json-example  \
	| jq " .\"local_port\" |= ${PORT} " \
	| jq " .\"remote_addr\" |= \"${FAKEDOMAIN}\" " \
	| jq " .\"password\"[0] |= \"${PASSWORD}\" " \
	| jq " .\"ssl\".\"cert\" |= \"/config/etc/letsencrypt/archive/${DUCKDOMAIN}.duckdns.org/fullchain1.pem\" " \
	| jq " .\"ssl\".\"key\" |= \"/config/etc/letsencrypt/archive/${DUCKDOMAIN}.duckdns.org/privkey1.pem\" " \
	>/config/server.json

exec /trojan/trojan /config/server.json
