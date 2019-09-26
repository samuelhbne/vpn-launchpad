#!/bin/bash

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

ARCH=`uname -m`
SVCID="brook"
CTNNAME="proxy-$SVCID"
SVRNAME="server-$SVCID"
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

DOCKERVER=`docker --version|awk '{print $3}'`
DKVERMAJOR=`echo $DOCKERVER|cut -d. -f1`
DKVERMINOR=`echo $DOCKERVER|cut -d. -f2`
if (("$DKVERMAJOR" < 17)) || ( (("$DKVERMAJOR" == 17)) && (("$DKVERMINOR" < 05 )) ); then
	echo "Unsupported Docker version $DOCKERVER, please upgrade to Docker version 18.09 at least"
	exit
fi

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

. $DIR/$SVRNAME.env
. $DIR/$CTNNAME.env

if [ -z "$VHOST" ] || [ -z "$BRKPORT" ] || [ -z "$BRKPASS" ]; then
	echo "Proxy config not found."
	echo "Abort."
	exit 1
fi

if [ `docker ps -a| grep $CTNNAME|wc -l` -gt 0 ]; then
        docker stop $CTNNAME >/dev/null
	docker rm $CTNNAME >/dev/null
fi

echo "Starting up local proxy daemon..."
docker run --name $CTNNAME -p $SOCKSPORT:1080 -p $DNSPORT:53/udp -p $HTTPPORT:8123 -d $IMGNAME:$TARGET client -l ${LSTNADDR}:1080 -i ${LSTNADDR} -s ${VHOST}:${BRKPORT} -p "${BRKPASS}" >/dev/null
echo "Done."
echo
