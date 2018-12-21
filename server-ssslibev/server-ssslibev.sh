#!/bin/bash

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

while [[ $# > 0 ]]; do
	case $1 in
		--from-src)
			BDSRC=1
			shift
			;;
		*)
			shift
			;;
	esac
done

if [[ "$BDSRC" = 1 ]]; then
	docker build --rm=true -t samuelhbne/server-ssslibev $DIR
fi

. $DIR/server-ssslibev.env

docker run --restart unless-stopped --name server-ssslibev -p $SSPORT:$SSPORT -p $SSPORT:$SSPORT/udp -d samuelhbne/server-ssslibev -s 0.0.0.0 -s ::0 -p $SSPORT -k $SSPASS -m $SSMTHD -t 300 --fast-open -d 8.8.8.8,8.8.4.4 -u
