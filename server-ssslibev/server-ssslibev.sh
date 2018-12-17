#!/bin/sh

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

. $DIR/server-ssslibev.env

docker build --rm=true -t samuelhbne/server-ssslibev $DIR
docker run --restart unless-stopped --name server-ssslibev -p $SSPORT:$SSPORT -p $SSPORT:$SSPORT/udp -d samuelhbne/server-ssslibev -s 0.0.0.0 -s ::0 -p $SSPORT -k $SSPASS -m $SSMTHD -t 300 --fast-open -d 8.8.8.8,8.8.4.4 -u
