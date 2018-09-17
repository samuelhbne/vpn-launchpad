#!/bin/sh

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

. $DIR/shadowsocks-libev.env

git clone https://github.com/EasyPi/docker-shadowsocks-libev
cd docker-shadowsocks-libev
sed -i "/server:/,/client:/ s/PASSWORD=5ouMnqPyzseL/PASSWORD=$SSPASS/g" docker-compose.yml
sed -i "/server:/,/client:/ s/8388:8388\/tcp/$SSTCPPORT:$SSTCPPORT\/tcp/g" docker-compose.yml
sed -i "/server:/,/client:/ s/8388:8388\/udp/$SSUDPPORT:$SSUDPPORT\/udp/g" docker-compose.yml
sed -i "/server:/,/client:/ s/METHOD=aes-256-cfb/METHOD=$SSMETHOD/g" docker-compose.yml
docker-compose up -d server
