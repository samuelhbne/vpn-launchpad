#!/bin/bash

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"
IMGNAME="samuelhbne/server-ssslibev"
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

case $1 in
	--from-src)
		docker build -t $IMGNAME:$TARGET -f $DIR/Dockerfile.$TARGET $DIR
		;;
	*)
		;;
esac

. $DIR/server-ssslibev.env

docker run --restart unless-stopped --name server-ssslibev -p $SSPORT:$SSPORT -p $SSPORT:$SSPORT/udp -d $IMGNAME:$TARGET -s 0.0.0.0 -s ::0 -p $SSPORT -k $SSPASS -m $SSMTHD -t 300 --fast-open -d 8.8.8.8,8.8.4.4 -u