#!/bin/sh

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

ARCH=`arch`
IMGNAME="samuelhbne/ssllibev"
IMGVER="$ARCH"
IMGTAG="$IMGNAME:$IMGVER"
CTNNAME="ssllibev"

. $DIR/ssslibev.env
. $DIR/ssllibev.env.out

BIMG=`docker images |grep $IMGNAME|grep -c $IMGVER`
TDKFILE=`date +%Y%m%d%H%M%S -r $DIR/Dockerfile.in`
TENVSSLL=`date +%Y%m%d%H%M%S -r $DIR/ssllibev.env`
TIMG=`docker inspect -f '{{ .Created }}' $IMGTAG`
TIMG=`date --date "$TIMG" +%Y%m%d%H%M%S`

if [ "$BIMG" = "0" ] || [ "$TDKFILE" -gt "$TIMG" ] || [ "$TENVSSLL" -gt "$TIMG" ]; then
	cp -a $DIR/Dockerfile.in $DIR/Dockerfile
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
	echo "Building local proxy image..."
	docker build --rm=true -t $IMGTAG -f $DIR/Dockerfile $DIR
	echo "Done."
	echo
fi

BEXIST=`docker ps -a| grep $CTNNAME|wc -l`
if [ $BEXIST -gt 0 ]; then
        docker stop $CTNNAME >/dev/null
	docker rm $CTNNAME >/dev/null
fi

echo "Starting up local proxy daemon..."
docker run --restart unless-stopped --name $CTNNAME -p $SOCKSPORT:$SOCKSPORT -p $DNSPORT:$DNSPORT/udp -p $HTTPPORT:$HTTPPORT -d $IMGTAG -s ${SSHOST} -p ${SSPORT} -b ${LISTENADDR} -l ${SOCKSPORT} -k "${SSPASS}" -m "${SSMETHOD}" >/dev/null
echo "Done."
echo
