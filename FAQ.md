# Frequently Asked Questions

- [Can I share VPN server with multiple Pi boxes located in different networks?](#can-i-share-vpn-server-with-multiple-pi-boxes-located-in-different-networks)
- [Can I build multiple VPN servers with the same AWS account?](#can-i-build-multiple-vpn-servers-with-the-same-aws-account)
- [What if vlp build build command stalled with no response?](#what-if-vlp-build-command-stalled-with-no-response)

## Can I share VPN server with multiple Pi boxes located in different networks?

Yes you can. `vlp --build` saves Shadowsocks connection parameters in VPN serever instance matadata. Hence all vpn-launchpad boxes configured with same AWS account and same region automaticly share the same VPN server instance.
- Initialise box1 via `vlp --init` with your Access Key ID and Secret Access Key
- Build VPN server on box1 with `vlp --build`
- Build local proxy on box1 with `lproxy --build`
- Initialise box2 via `vlp --init` with the same Access Key ID and Secret Access Key used by box1
- Build local proxy on box2 with `lproxy --build`
- Done.


## Can I build multiple VPN servers with the same AWS account?

Yes you can. But they must be located in different regions. For example: one in ap-northeast-1 and one in ap-northeast-2


## What if vlp build command stalled with no response?

Stop it with Ctl-C then run "vlp --purge" to purge possible partially created VPN server.
