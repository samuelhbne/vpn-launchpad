#!/bin/sh

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

. $DIR/ssserver.env
. $DIR/sslocal.env

ARCH=`arch`
if [ "$ARCH" = "armv6l" ]; then
	sed -i 's/^FROM .*/FROM arm32v6\/alpine/g' $DIR/Dockerfile
elif [ "$ARCH" = "armv7l" ]; then
	sed -i 's/^FROM .*/FROM arm32v6\/alpine/g' $DIR/Dockerfile
else
	sed -i 's/^FROM .*/FROM alpine/g' $DIR/Dockerfile
fi

sed -i "s/EXPOSE.*/EXPOSE $SOCKSPORT $DNSPORT $HTTPPORT/g" $DIR/Dockerfile
sed -i "s/SOCKSPORT=.*/SOCKSPORT=\"$SOCKSPORT\"/g" $DIR/Dockerfile
sed -i "s/HTTPPORT=.*/HTTPPORT=\"$HTTPPORT\"/g" $DIR/Dockerfile
sed -i "s/DNSPORT=.*/DNSPORT=\"$DNSPORT\"/g" $DIR/Dockerfile
sed -i "s/DNSPORT=.*/DNSPORT=\"$DNSPORT\"/g" $DIR/run.sh

docker build --rm=true -t samuelhbne/sslocal -f $DIR/Dockerfile $DIR

BEXIST=`docker ps -a| grep sslocal|wc -l`
if [ $BEXIST -gt 0 ]; then
        docker stop sslocal; docker rm sslocal
fi

echo "docker run --name sslocal -p $SOCKSPORT:$SOCKSPORT -p $DNSPORT:$DNSPORT/udp -p $HTTPPORT:$HTTPPORT -d samuelhbne/sslocal -s ${SSHOST} -p ${SSTCPPORT} -b ${SOCKSADDR} -l ${SOCKSPORT} -k \"${SSPASS}\" -m \"${SSMETHOD}\""
docker run --name sslocal -p $SOCKSPORT:$SOCKSPORT -p $DNSPORT:$DNSPORT/udp -p $HTTPPORT:$HTTPPORT -d samuelhbne/sslocal -s ${SSHOST} -p ${SSTCPPORT} -b ${SOCKSADDR} -l ${SOCKSPORT} -k "${SSPASS}" -m "${SSMETHOD}"
