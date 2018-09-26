#!/bin/bash

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

VLPCMD=$DIR/docker-vlp

echo "Query VPS IP address..."
VPSIP=`$VLPCMD --query|grep "VPN SERVER:"|cut -d ':' -f2|cut -d' ' -f2|tr -d '\r\n'`

if [ "$VPSIP" = "None" ]; then
	echo "VPS not found."
else
	echo "Found VPS: $VPSIP"
	echo "Setting up local proxy..."
	cp -a $DIR/docker-ssserver/ssserver.env $DIR/docker-client-sslocal/
	sed -i "s/SSHOST=.*/SSHOST=$VPSIP/g" $DIR/docker-client-sslocal/client-sslocal.env
	$DIR/docker-client-sslocal/client-sslocal.sh
	echo "Done."
	echo
	echo
	. $DIR/docker-client-sslocal/client-sslocal.env
	echo "VPS: $VPSIP"

	sleep 5
	echo
	echo "Testing local proxy http://127.0.0.1:$HTTPPORT"
	echo "curl -v -x http://127.0.0.1:$HTTPPORT http://ifconfig.co"
	curl -v -x http://127.0.0.1:$HTTPPORT ifconfig.co
	echo
	echo "Testing local proxy socks5://127.0.0.1:$SOCKSPORT"
	echo "curl -v -x socks5://127.0.0.1:$SOCKSPORT ifconfig.co"
	curl -v -x socks5://127.0.0.1:$SOCKSPORT ifconfig.co
fi
