#!/bin/bash

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

VLPCMD=$DIR/docker-vlp

VPSIP=`$VLPCMD --query|grep "VPN SERVER:"|cut -d ':' -f2|cut -d' ' -f2|tr -d '\r\n'`

if [ "$VPSIP" = "None" ]; then
	echo "VPS not found."
else
	echo "Found VPS: $VPSIP"
	echo "Setting up local proxy..."
	cp -a $DIR/docker-v2rays/docker-v2rays.env $DIR/docker-client-v2ray/
	sed -i "s/V2RAYHOST=.*/V2RAYHOST=$VPSIP/g" $DIR/docker-client-v2ray/docker-client-v2ray.env
	$DIR/docker-client-v2ray/docker-client-v2ray.sh
	sleep 10
	echo "Done."
	echo
	echo
	. $DIR/docker-client-v2ray/docker-client-v2ray.env
	echo "VPS: $VPSIP"
	echo
	echo "Testing local proxy http://127.0.0.1:$HTTPPORT"
	echo "curl -x http://127.0.0.1:$HTTPPORT http://ifconfig.co"
	curl -v -x http://127.0.0.1:$HTTPPORT ifconfig.co
	echo
	echo "Testing local proxy socks5://127.0.0.1:$SOCKSPORT"
	echo "curl -v -x socks5://127.0.0.1:$SOCKSPORT ifconfig.co"
	curl -v -x socks5://127.0.0.1:$SOCKSPORT ifconfig.co
fi
