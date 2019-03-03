#!/bin/bash

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

ARCH=`uname -m`
SVCID="v2ray"
CTNNAME="proxy-$SVCID"
IMGNAME="samuelhbne/proxy-$SVCID"

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

. $DIR/server-$SVCID.env
. $DIR/proxy-$SVCID.env.out

BEXIST=`docker ps -a| grep $CTNNAME|wc -l`
if [ $BEXIST -gt 0 ]; then
        docker stop $CTNNAME >/dev/null
	docker rm $CTNNAME >/dev/null
fi

echo "Starting up local proxy daemon..."
docker run --name $CTNNAME -p $SOCKSPORT:1080 -p $DNSPORT:53/udp -p $HTTPPORT:8123 -d $IMGNAME:$TARGET -h ${HOST} -p ${V2RAYPORT} -u ${V2RAYUUID} -l ${LSTNADDR} -k 1080 >/dev/null
echo "Done."
echo
