#!/bin/bash

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"
IMGNAME="samuelhbne/server-sslibev"
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

. $DIR/server-sslibev.env

docker run --restart unless-stopped --name server-sslibev -p $SSPORT:8388 -p $SSPORT:8388/udp -d $IMGNAME:$TARGET -s 0.0.0.0 -s ::0 -p 8388 -k $SSPASS -m $SSMTHD -t 300 --fast-open -d 8.8.8.8,8.8.4.4 -u
