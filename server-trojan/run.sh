#!/bin/bash

usage() { echo "Usage: $0 -d <domain-name> -w <password> [-r] [-f <fake-domain-name>]" 1>&2; exit 1; }
while getopts ":d:f:w:" o; do
	case "${o}" in
		d)
			DOMAIN="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		f)
			FAKEDOMAIN="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		w)
			PASSWORD="$(echo -e "${OPTARG}" | tr -d '[:space:]')"
			;;
		r)
			RENEW=true
			;;
		*)
		       	usage;
	esac
done

if [ -z "${PASSWORD}" ] || [ -z "${DOMAIN}" ]; then
	usage
	exit 2
fi

if [ -z "${FAKEDOMAIN}" ]; then
	FAKEDOMAIN="www.microsoft.com"
fi

PORT=443

shift $((OPTIND-1))

if [ ! -f "/root/.acme.sh/${DOMAIN}/fullchain.cer" ] || [ "$RENEW" = true ]; then
	/root/.acme.sh/acme.sh --issue --standalone --force -d ${DOMAIN}
	if [ ! -f "/root/.acme.sh/${DOMAIN}/fullchain.cer" ]; then
		echo "Obtian cert for ${DOMAIN} failed. Check log please."
		exit 3
	fi
fi

cat /trojan/examples/server.json-example  \
	| jq " .\"local_port\" |= ${PORT} " \
	| jq " .\"remote_addr\" |= \"${FAKEDOMAIN}\" " \
	| jq " .\"password\"[0] |= \"${PASSWORD}\" " \
	| jq " .\"ssl\".\"cert\" |= \"/root/.acme.sh/${DOMAIN}/fullchain.cer\" " \
	| jq " .\"ssl\".\"key\" |= \"/root/.acme.sh/${DOMAIN}/${DOMAIN}.key\" " \
	>/config/server.json

exec /trojan/trojan /config/server.json
