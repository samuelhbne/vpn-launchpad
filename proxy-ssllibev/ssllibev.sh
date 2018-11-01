#!/bin/sh

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

. $DIR/ssslibev.env
. $DIR/ssllibev.env.out

cp -a $DIR/Dockerfile.in $DIR/Dockerfile
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

docker build --rm=true -t samuelhbne/ssllibev -f $DIR/Dockerfile $DIR

BEXIST=`docker ps -a| grep ssllibev|wc -l`
if [ $BEXIST -gt 0 ]; then
        docker stop ssllibev; docker rm ssllibev
fi

echo "docker run --name ssllibev -p $SOCKSPORT:$SOCKSPORT -p $DNSPORT:$DNSPORT/udp -p $HTTPPORT:$HTTPPORT -d samuelhbne/ssllibev -s ${SSHOST} -p ${SSTCPPORT} -b ${LISTENADDR} -l ${SOCKSPORT} -k \"${SSPASS}\" -m \"${SSMETHOD}\""
docker run --name ssllibev -p $SOCKSPORT:$SOCKSPORT -p $DNSPORT:$DNSPORT/udp -p $HTTPPORT:$HTTPPORT -d samuelhbne/ssllibev -s ${SSHOST} -p ${SSPORT} -b ${LISTENADDR} -l ${SOCKSPORT} -k "${SSPASS}" -m "${SSMETHOD}"
