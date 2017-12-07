#!/bin/bash

DIR=`dirname $0`
DIR=`realpath $DIR`

echo $DIR

docker build --rm=true -t samuelhbne/vpnlaunchpad docker-vpnlaunchpad

mkdir -p $DIR/.vpn-launchpad/.aws
if [ ! -f $DIR/.vpn-launchpad/.aws/config ]; then
	echo "[default]\nregion = ap-northeast-1\noutput = json\n">>$DIR/.vpn-launchpad/.aws/config
fi
docker run --rm=true --name vpnlaunchpad -v $DIR:/home/ubuntu/vpn-launchpad -v $DIR/.vpn-launchpad/.aws:/home/ubuntu/.aws -v $DIR/.vpn-launchpad:/home/ubuntu/.vpn-launchpad -it samuelhbne/vpnlaunchpad

