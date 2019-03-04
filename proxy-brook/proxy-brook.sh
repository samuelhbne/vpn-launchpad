#!/bin/bash

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

ARCH=`uname -m`
IMGNAME="samuelhbne/proxy-brook"
CTNNAME="proxy-brook"

case $ARCH in
	armv6l|armv7l)
		TARGET=arm
		;;
	x86_64|i686|i386)
		TARGET=amd64
		;;
	aarch64)
		TARGET=arm64
		;;
	*)
		echo "Unsupported arch"
		exit
		;;
esac

while [[ $# > 0 ]]; do
	case $1 in
		--from-src)
			echo "Building local proxy image..."
			docker build -t $IMGNAME:$TARGET -f $DIR/Dockerfile.$TARGET $DIR
			echo "Done."
			echo
			break
			;;
		*)
			shift
			;;
	esac
done

. $DIR/server-brook.env
. $DIR/proxy-brook.env.out

if [ -z "$HOST" ] || [ -z "$BRKPORT" ] || [ -z "$BRKPASS" ]; then
	echo "Brook service not found."
	echo "Abort."
	exit 1
fi

if [ `docker ps -a| grep $CTNNAME|wc -l` -gt 0 ]; then
        docker stop $CTNNAME >/dev/null
	docker rm $CTNNAME >/dev/null
fi

echo "Starting up local proxy daemon..."
docker run --name $CTNNAME -p $SOCKSPORT:1080 -p $DNSPORT:53/udp -p $HTTPPORT:8123 -d $IMGNAME:$TARGET client -l ${LSTNADDR}:1080 -i ${LSTNADDR} -s ${HOST}:${BRKPORT} -p "${BRKPASS}" >/dev/null
echo "Done."
echo
