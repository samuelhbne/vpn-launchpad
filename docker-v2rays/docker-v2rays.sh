#!/bin/sh

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

. $DIR/docker-v2rays.env

sed -i "/EXPOSE/,/\n/ s/8000/$VMESSPORT/g" Dockerfile
sed -i "/inbound/,/vmess/ s/8000/$VMESSPORT/g" server.json
sed -i "/clients/,/alterId/ s/138c5e58-cd7a-455f-bef4-03016b15e6d2/$UUID/g" server.json 
sed -i "/alterId/,/\n/ s/64/$ALTERID/g" server.json

docker build --rm=true -t samuelhbne/v2rays .
docker run --name v2rays -p $VMESSPORT:8000 -v $DIR/server.json:/etc/v2ray/config.json -d samuelhbne/v2rays
