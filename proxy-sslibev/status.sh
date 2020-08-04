#!/bin/bash

SSHOST=`ps|grep /usr/bin/ss-local|grep -v grep|sed 's/ -/\n/g'|grep "^s "|awk '{print $2}'`
SSPORT=`ps|grep /usr/bin/ss-local|grep -v grep|sed 's/ -/\n/g'|grep "^p "|awk '{print $2}'`
SSPASS=`ps|grep /usr/bin/ss-local|grep -v grep|sed 's/ -/\n/g'|grep "^k "|awk '{print $2}'`
SSMTHD=`ps|grep /usr/bin/ss-local|grep -v grep|sed 's/ -/\n/g'|grep "^m "|awk '{print $2}'`
SSUINFO=`echo "$SSMTHD:$SSPASS"|tr -d '\n'|base64|tr -d '\n'`

SSIP=`dig +short $SSHOST|head -n1`
if [ -z "$SSIP" ]; then
    SSIP=$SSHOST
fi

echo "VPS-Server: $SSIP"
echo "Shadowsocks-URL: ss://$SSUINFO@$IPADDR:$SSPORT#VLP-shadowsocks"
qrcode-terminal "ss://$SSUINFO@$IPADDR:$SSPORT#VLP-shadowsocks"
