#!/bin/sh

SSPASS="YOUR-SHADOWSOCKS-PASS"
SSTCPPORT="8388"
SSUDPPORT="8388"
SSMETHOD="aes-256-cfb"

git clone https://github.com/EasyPi/docker-shadowsocks-libev
cd docker-shadowsocks-libev
sed -i "/server:/,/client:/ s/PASSWORD=5ouMnqPyzseL/PASSWORD=$SSPASS/g" docker-compose.yml
sed -i "/server:/,/client:/ s/8388:8388\/tcp/$SSTCPPORT:$SSTCPPORT\/tcp/g" docker-compose.yml
sed -i "/server:/,/client:/ s/8388:8388\/udp/$SSUDPPORT:$SSUDPPORT\/udp/g" docker-compose.yml
sed -i "/server:/,/client:/ s/METHOD=aes-256-cfb/METHOD=$SSMETHOD/g" docker-compose.yml
docker-compose up -d server
