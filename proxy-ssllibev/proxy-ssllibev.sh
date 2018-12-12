#!/bin/sh

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

ARCH=`uname -m`
IMGNAME="samuelhbne/proxy-ssllibev"
CTNNAME="proxy-ssllibev"

. $DIR/ssslibev.env
. $DIR/proxy-ssllibev.env.out

#BIMG=`docker images |grep $IMGNAME|grep -c $IMGVER`
#TDKFILE=`date +%Y%m%d%H%M%S -r $DIR/Dockerfile.in`
#TENVSSLL=`date +%Y%m%d%H%M%S -r $DIR/proxy-ssllibev.env`
#TIMG=`docker inspect -f '{{ .Created }}' $IMGTAG 2>/dev/null`
#TIMG=`date --date "$TIMG" +%Y%m%d%H%M%S`

#if [ "$BIMG" = "0" ] || [ "$TDKFILE" -gt "$TIMG" ] || [ "$TENVSSLL" -gt "$TIMG" ]; then
	case $ARCH in
		armv6l|armv7l)
			TARGET=arm32v6
			;;
		x86_64|i686|i386)
			TARGET=amd64
			;;
		*)
			echo "Unsupported arch"
			exit
			;;
	esac
	echo "Building local proxy image..."
	docker build -t $IMGNAME:$TARGET -f $DIR/Dockerfile.$TARGET $DIR
	echo "Done."
	echo
#fi

BEXIST=`docker ps -a| grep $CTNNAME|wc -l`
if [ $BEXIST -gt 0 ]; then
        docker stop $CTNNAME >/dev/null
	docker rm $CTNNAME >/dev/null
fi

echo "Starting up local proxy daemon..."
docker run --name $CTNNAME -p $SOCKSPORT:1080 -p $DNSPORT:53/udp -p $HTTPPORT:8123 -d $IMGNAME:$TARGET -s ${SSHOST} -p ${SSPORT} -b ${LISTENADDR} -l ${SOCKSPORT} -k "${SSPASS}" -m "${SSMTHD}" >/dev/null
echo "Done."
echo
