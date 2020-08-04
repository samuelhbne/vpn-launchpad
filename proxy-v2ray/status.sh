#!/bin/bash

ADDRESS=`cat /tmp/client.json|jq -r ' ."outbounds"[0]."settings"."vnext"[0]."address" '`
PORT=`cat /tmp/client.json|jq -r ' ."outbounds"[0]."settings"."vnext"[0]."port" '`
UUID=`cat /tmp/client.json|jq -r ' ."outbounds"[0]."settings"."vnext"[0]."users"[0]."id" '`
ALTERID=`cat /tmp/client.json|jq -r ' ."outbounds"[0]."settings"."vnext"[0]."users"[0]."alterId" '`

V2RAYINFO=`echo "{'add':'$ADDRESS','aid':'$ALTERID','id':'$UUID','net':'tcp','port':'$PORT','ps':'VLP-V2RAY'}"`
V2RAYINFO=`echo $V2RAYINFO|base64|tr -d '\n'`
echo "V2Ray-vmess-URI: vmess://$V2RAYINFO"
qrcode-terminal "vmess://$V2RAYINFO"
