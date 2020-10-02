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
	armv6l|armv7l)
		# Raspberry Pi
		TARGET=arm
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

case $DNSUPDATE in
	duckdns)
		echo "Update $DUCKDNSDOMAIN.duckdns.org IP address..."
		RESULT=`curl -sSL "https://duckdns.org/update/$DUCKDNSDOMAIN/$DUCKDNSTOKEN"`
		echo "$RESULT"
		if [ "$RESULT" != "OK" ]; then
			echo "DNS update failed."
			exit 253
		fi
		TRJDOMAIN="${DUCKDNSDOMAIN}.duckdns.org"
		echo "Domain-name $TRJDOMAIN updated."
		echo
		;;
	*)
		echo "Unsupported DNS update service."
		exit 254
		;;
esac

echo "Starting server-trojan ..."
docker run --name server-trojan	-p 80:80 -p $TRJPORT:443 -d $IMGNAME:$TARGET \
	-d ${TRJDOMAIN} -w $TRJPASS -f $TRJFAKEDOMAIN
echo

sleep 5

CNT=`docker ps|grep server-trojan -c`

if [ $CNT > 0 ]; then
	echo "server-trojan started."
	echo "Done"
	exit 0
else
	echo "Starting server-trojan failed. Check detail with 'docker logs server-trojan'"
	exit 252
fi