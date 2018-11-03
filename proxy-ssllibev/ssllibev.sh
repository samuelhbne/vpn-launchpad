#!/bin/sh

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

. $DIR/ssslibev.env
. $DIR/ssllibev.env.out

cp -a $DIR/Dockerfile.in $DIR/Dockerfile
ARCH=`arch`
case $ARCH in
	armv6l|armv7l)
		sed -i.bak 's/^FROM .*/FROM arm32v6\/alpine/g' $DIR/Dockerfile
		;;
	x86_64|i686|i386)
		sed -i.bak 's/^FROM .*/FROM alpine/g' $DIR/Dockerfile
		;;
	*)
		echo "Unsupported arch"
		exit
		;;
esac

sed -i.bak "s/EXPOSE.*/EXPOSE $SOCKSPORT $DNSPORT $HTTPPORT/g" $DIR/Dockerfile
sed -i.bak "s/SOCKSPORT=.*/SOCKSPORT=\"$SOCKSPORT\"/g" $DIR/Dockerfile
sed -i.bak "s/HTTPPORT=.*/HTTPPORT=\"$HTTPPORT\"/g" $DIR/Dockerfile
sed -i.bak "s/DNSPORT=.*/DNSPORT=\"$DNSPORT\"/g" $DIR/Dockerfile
rm -rf $DIR/Dockerfile.bak

docker build --rm=true -t samuelhbne/ssllibev -f $DIR/Dockerfile $DIR

BEXIST=`docker ps -a| grep ssllibev|wc -l`
if [ $BEXIST -gt 0 ]; then
        docker stop ssllibev; docker rm ssllibev
fi

echo "docker run --name ssllibev -p $SOCKSPORT:$SOCKSPORT -p $DNSPORT:$DNSPORT/udp -p $HTTPPORT:$HTTPPORT -d samuelhbne/ssllibev -s ${SSHOST} -p ${SSTCPPORT} -b ${LISTENADDR} -l ${SOCKSPORT} -k \"${SSPASS}\" -m \"${SSMETHOD}\""
docker run --name ssllibev -p $SOCKSPORT:$SOCKSPORT -p $DNSPORT:$DNSPORT/udp -p $HTTPPORT:$HTTPPORT -d samuelhbne/ssllibev -s ${SSHOST} -p ${SSPORT} -b ${LISTENADDR} -l ${SOCKSPORT} -k "${SSPASS}" -m "${SSMETHOD}"
