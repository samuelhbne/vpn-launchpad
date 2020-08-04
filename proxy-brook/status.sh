#!/bin/bash

BRKSVC=`ps|grep /go/bin/brook|grep -v grep|sed 's/ -/\n/g'|grep "^s "|awk '{print $2}'`
BRKPASS=`ps|grep /go/bin/brook|grep -v grep|sed 's/ -/\n/g'|grep "^p "|awk '{print $2}'`
BRKINFO=`url -p "$BRKSVC $BRKPASS"`

BRKSVR=`echo $BRKSVC|cut -d ':' -f1`
BRKIP=`dig +short $BRKSVR|head -n1`
if [ -z "$BRKIP" ]; then
    BRKIP=$BRKSVR
fi

echo "VPS-Server: $BRKIP"
echo "Brook-URL: brook://$BRKINFO"
/go/bin/brook qr -s $BRKSVC -p $BRKPASS
