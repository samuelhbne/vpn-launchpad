#!/bin/sh

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

. $DIR/docker-v2rays.env
. $DIR/docker-client-v2ray.env

sed -i "s/EXPOSE.*/EXPOSE $SOCKSPORT $DNSVRPORT $HTTPPORT/g" $DIR/Dockerfile
sed -i "s/SOCKSPORT=.*/SOCKSPORT=$SOCKSPORT/g" $DIR/Dockerfile
sed -i "s/DNSVRPORT=.*/DNSVRPORT=$DNSVRPORT/g" $DIR/Dockerfile
sed -i "s/HTTPPORT=.*/HTTPPORT=$HTTPPORT/g" $DIR/Dockerfile
sed -i "/inbound/,/settings/ s/\"port\":.*/\"port\": $SOCKSPORT,/g" $DIR/client.json

sed -i "/outbound/,/level/ s/\"address\":.*/\"address\": \"$V2RAYHOST\",/g" $DIR/client.json
sed -i "/outbound/,/level/ s/\"port\":.*/\"port\": $VMESSPORT,/g" $DIR/client.json
sed -i "/outbound/,/level/ s/\"id\":.*/\"id\": \"$UUID\",/g" $DIR/client.json
sed -i "/outbound/,/level/ s/\"alterId\":.*/\"alterId\": $ALTERID,/g" $DIR/client.json

docker build --rm=true -t samuelhbne/v2rayc $DIR

BV2RAYC=`docker ps -a| grep v2rayc|wc -l`
if [ $BV2RAYC -gt 0 ]; then
        docker stop v2rayc; docker rm v2rayc
fi
docker run --name v2rayc -p $SOCKSPORT:$SOCKSPORT -p $DNSVRPORT:$DNSVRPORT/udp -p $HTTPPORT:$HTTPPORT -v $DIR/client.json:/etc/v2ray/client.json -d samuelhbne/v2rayc
