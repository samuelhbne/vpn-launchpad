#!/bin/bash

TJHOST=`cat /config/client.json| jq -r ' ."remote_addr" '`
TJPORT=`cat /config/client.json| jq -r ' ."remote_port" '`
TJPASS=`cat /config/client.json| jq -r ' ."password"[0] '`

echo "Trojan-URL: trojan://${TJPASS}@${TJHOST}:${TJPORT}"
qrcode-terminal "trojan://${TJPASS}@${TJHOST}:${TJPORT}"
