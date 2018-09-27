#!/bin/sh

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

. $DIR/ssserver.env

#sed -i "s/server_port\":.*/server_port\":\"$SSTCPPORT\",/g" $DIR/ssserver.json
#sed -i "s/method\":.*/method\":\"$SSMETHOD\",/g" $DIR/ssserver.json
#sed -i "s/password\":.*/password\":\"$SSPASS\",/g" $DIR/ssserver.json

docker build --rm=true -t samuelhbne/ssserver $DIR
docker run --rm=true --name ssserver -p $SSTCPPORT:$SSTCPPORT -d samuelhbne/ssserver -s 0.0.0.0 -p $SSTCPPORT -k $SSPASS -m $SSMETHOD
