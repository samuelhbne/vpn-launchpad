#!/bin/sh

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

. $DIR/ssslibev.env

docker build --rm=true -t samuelhbne/ssslibev $DIR
docker run --rm=true --name ssslibev -p $SSPORT:$SSPORT -p $SSPORT:$SSPORT/udp -d samuelhbne/ssslibev -s 0.0.0.0 -s ::0 -p $SSPORT -k $SSPASS -m $SSMETHOD -t 300 --fast-open -d 8.8.8.8,8.8.4.4 -u
