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
	cp -a $DIR/server-ssserver/ssserver.env $DIR/client-sslocal/
	sed -i "s/SSHOST=.*/SSHOST=$VPSIP/g" $DIR/client-sslocal/sslocal.env
	$DIR/client-sslocal/sslocal.sh
	echo "Done."
	echo
	echo
	. $DIR/client-sslocal/sslocal.env
	echo "Found VPS: $VPSIP"
	sleep 5

	echo
	echo "Testing local HTTP PROXY on TCP:$HTTPPORT ..."
	echo
	echo "curl -x http://127.0.0.1:$HTTPPORT http://ifconfig.co"
	curl -x http://127.0.0.1:$HTTPPORT ifconfig.co

	echo
	echo "Testing local SOCKS PROXY on TCP:$SOCKSPORT ..."
	echo
	echo "curl -x socks5://127.0.0.1:$SOCKSPORT ifconfig.co"
	curl -x socks5://127.0.0.1:$SOCKSPORT ifconfig.co

	echo
	echo "Testing local DNS proxy on UDP:$DNSPORT ..."
	echo
	echo "dig @127.0.0.1 -p $DNSPORT twitter.com"
	dig @127.0.0.1 -p $DNSPORT twitter.com
fi
