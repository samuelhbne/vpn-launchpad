# Frequently Asked Questions
- [What if vlp build build command stalled with no response?](#what-if-vlp-build-command-stalled-with-no-response)
- [What if Local proxy stops working after I rebuilt VPN server?](#what-if-local-proxy-stops-working-after-i-rebuilt-vpn-server)
- [Can I build multiple VPN servers with the same AWS account?](#can-i-build-multiple-vpn-servers-with-the-same-aws-account)
- [Can I create an instance other than t2.micro for saving money?](#can-i-create-an-instance-other-than-t2micro-for-saving-money)
- [Can I share VPN server with multiple Pi boxes located in different sites?](#can-i-share-vpn-server-with-multiple-pi-boxes-located-in-different-sites)


## What if 'vlp build' command stalled with no response?
You can stop 'vlp build' with Ctl+C if it stalls more than 5 minutes waiting for the response from AWS command centre. Then run "vlp purge" to purge the possible partially created VPN server and try 'vlp build' again.


## What if Local proxy stops working after I rebuilt VPN server?
VPN server IP address may changed after rebuilding. Running "lproxy build" again will remove the current running proxy container from Pi box and start a new proxy with updated server settings.


## Can I build multiple VPN servers with the same AWS account?
Yes. But they must be located in different regions. For example: one in ap-northeast-1 and one in ap-northeast-2. Another words: one server in a region.


## Can I create an instance other than t2.micro for saving money?
Yes. Modify the settings in $VLPHOME/vlp.env please.
```
$ cat vlp.env 
UBUNTUVER="bionic"
STACKID="vlp-$UBUNTUVER"
PROFILE="default"
INSTYPE="t2.micro"
INSTARCH="x86_64"
```


## Can I share VPN server with multiple Pi boxes located in different sites?
Yes. 'vlp build' saves Shadowsocks connection parameters in VPN serever instance matadata. Hence all vpn-launchpad boxes configured with same AWS account and same region automaticly share the same VPN server instance.
- Initialise box1 via 'vlp init' with your Access Key ID and Secret Access Key
- Build VPN server on box1 with 'vlp build'
- Build local proxy on box1 with 'lproxy build'
- Initialise box2 via 'vlp init' with the same Access Key ID and Secret Access Key used by box1
- Build local proxy on box2 with 'lproxy build'
- Done.
