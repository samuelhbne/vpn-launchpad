#!/bin/sh

PASSWORD="YOUR-SHADOWSOCKS-PASS"

git clone https://github.com/EasyPi/docker-shadowsocks-libev
cd docker-shadowsocks-libev
sed -i 's/PASSWORD=5ouMnqPyzseL/PASSWORD=$PASSWORD/g' docker-compose.yml
docker-compose up -d server
