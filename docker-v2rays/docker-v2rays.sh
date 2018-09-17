#!/bin/sh

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

. $DIR/docker-v2rays.env

sed -i "s/EXPOSE.*/EXPOSE $VMESSPORT/g" $DIR/Dockerfile
sed -i "/inbound/,/settings/ s/\"port\":.*/\"port\": $VMESSPORT,/g" $DIR/server.json
sed -i "/inbound/,/outbound/ s/\"id\":.*/\"id\": \"$UUID\",/g" $DIR/server.json
sed -i "/inbound/,/outbound/ s/\"alterId\":.*/\"alterId\": $ALTERID,/g" $DIR/server.json

docker build --rm=true -t samuelhbne/v2rays $DIR
docker run --name v2rays -p $VMESSPORT:$VMESSPORT -v $DIR/server.json:/etc/v2ray/server.json -d samuelhbne/v2rays

