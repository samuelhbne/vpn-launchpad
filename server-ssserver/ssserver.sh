#!/bin/sh

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

. $DIR/ssserver.env

docker build --rm=true -t samuelhbne/ssserver $DIR
docker run --rm=true --name ssserver -p $SSTCPPORT:$SSTCPPORT -d samuelhbne/ssserver -s 0.0.0.0 -p $SSTCPPORT -k $SSPASS -m $SSMETHOD
