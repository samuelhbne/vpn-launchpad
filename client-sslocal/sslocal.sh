#!/bin/sh

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

. $DIR/ssserver.env
. $DIR/sslocal.env

sed -i "s/EXPOSE.*/EXPOSE $SOCKSPORT $DNSPORT $HTTPPORT/g" $DIR/Dockerfile.rspi
sed -i "s/SOCKSPORT=.*/SOCKSPORT=\"$SOCKSPORT\"/g" $DIR/Dockerfile.rspi
sed -i "s/DNSPORT=.*/DNSPORT=\"$DNSPORT\"/g" $DIR/Dockerfile.rspi
sed -i "s/HTTPPORT=.*/HTTPPORT=\"$HTTPPORT\"/g" $DIR/Dockerfile.rspi

docker build --rm=true -t samuelhbne/sslocal -f $DIR/Dockerfile.rspi $DIR

BEXIST=`docker ps -a| grep sslocal|wc -l`
if [ $BEXIST -gt 0 ]; then
        docker stop sslocal; docker rm sslocal
fi

echo "docker run --name sslocal -p $SOCKSPORT:$SOCKSPORT -p $DNSPORT:$DNSPORT/udp -p $HTTPPORT:$HTTPPORT -d samuelhbne/sslocal -s ${SSHOST} -p ${SSTCPPORT} -b ${SOCKSADDR} -l ${SOCKSPORT} -k \"${SSPASS}\" -m \"${SSMETHOD}\""
docker run --name sslocal -p $SOCKSPORT:$SOCKSPORT -p $DNSPORT:$DNSPORT/udp -p $HTTPPORT:$HTTPPORT -d samuelhbne/sslocal -s ${SSHOST} -p ${SSTCPPORT} -b ${SOCKSADDR} -l ${SOCKSPORT} -k "${SSPASS}" -m "${SSMETHOD}"
