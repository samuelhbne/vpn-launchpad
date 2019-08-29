#!/bin/bash

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"
IMGNAME="samuelhbne/server-trojan"
ARCH=`uname -m`

case $ARCH in
	x86_64|i686|i386)
		TARGET=amd64
		;;
	aarch64)
		# Amazon A1 instance
		TARGET=arm64
		;;
	*)
		echo "Unsupported arch"
		exit 255
		;;
esac

while [[ $# > 0 ]]; do
	case $1 in
		--from-src)
			docker build -t $IMGNAME:$TARGET -f $DIR/Dockerfile.$TARGET $DIR
			break
			;;
		*)
			shift
			;;
	esac
done

. $DIR/server-trojan.env

echo "Update $DUCKDNSDOMAIN.duckdns.org IP address..."
wget -qO- "https://duckdns.org/update/$DUCKDNSDOMAIN/$DUCKDNSTOKEN"
echo

echo "Obtain cert from letsencrypt..."
docker run \
  --name=letsencrypt \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e URL="$DUCKDNSDOMAIN.duckdns.org" \
  -e SUBDOMAINS=$DUCKSUBDOMAINS, \
  -e VALIDATION=duckdns \
  -e DUCKDNSTOKEN=$DUCKDNSTOKEN \
  -e STAGING=false \
  -p 8443:443 \
  -p 8080:80 \
  -v $DIR/config:/config \
  -d linuxserver/letsencrypt

CERT="$DIR/config/etc/letsencrypt/archive/$DUCKDNSDOMAIN.duckdns.org/fullchain1.pem"
KEY="$DIR/config/etc/letsencrypt/archive/$DUCKDNSDOMAIN.duckdns.org/privkey1.pem"
LEFT=300
while [ $LEFT -gt 0 ]; do
	sleep 1
	if [ -f $CERT ] && [ -f $KEY ]; then
		echo
		echo "Cert obtained."
		#docker stop letsencrypt
		docker run --name server-trojan --restart unless-stopped \
			-v $DIR/config:/config -p $TRJPORT:443 -d $IMGNAME:$TARGET \
			-p 443 -w $TRJPASS -f $TRJFAKEDOMAIN -t $DUCKDNSTOKEN -d $DUCKDNSDOMAIN
		exit 0
		break;
	fi
	echo -en "\r$LEFT sec left:\t"`docker logs letsencrypt 2>&1|tail -n1`"\t\t\t\t"
	((LEFT--))
done

docker logs letsencrypt
echo
echo "Cert obtaining failed."
echo "Please check letsencrypt log above for details."
echo "Abort server-trojan provisioning."
exit 255
