#!/bin/bash

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"
SVCID="v2ray"
CTNNAME="server-$SVCID"
IMGNAME="samuelhbne/server-$SVCID"
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

. $DIR/server-$SVCID.env

docker run --restart unless-stopped --name $CTNNAME -p $V2RAYPORT:10086 -d $IMGNAME:$TARGET -p 10086 -u $V2RAYUUID -v $V2RAYLEVEL -a $V2RAYAID
