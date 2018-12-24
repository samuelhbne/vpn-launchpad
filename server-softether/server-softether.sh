#!/bin/sh

DIR=`dirname $0`
ARCH=`uname -m`

case $ARCH in
	x86_64|i686|i386)
		TARGET=amd64
		;;
	*)
		echo "Unsupported arch"
		exit 255
		;;
esac

docker run --restart unless-stopped --name server-softether --env-file $DIR/server-softether.env --cap-add NET_ADMIN -p 500:500/udp -p 4500:4500/udp -p 1701:1701/tcp -p 1194:1194/udp -p 5555:5555/tcp -d siomiz/softethervpn
