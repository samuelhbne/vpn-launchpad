#!/bin/bash

BRKSVR=`ps|grep /go/bin/brook|grep -v grep|sed 's/ -/\n/g'|grep "^s "|awk '{print $2}'`
BRKPASS=`ps|grep /go/bin/brook|grep -v grep|sed 's/ -/\n/g'|grep "^p "|awk '{print $2}'`

SSUINFO=`echo "$SSMTHD:$SSPASS"|tr -d '\n'|base64|tr -d '\n'`

BRKINFO=`url -p "$BRKSVR $BRKPASS"`
echo "Brook-URL: brook://$BRKINFO"
/go/bin/brook qr -s $BRKSVR -p $BRKPASS
