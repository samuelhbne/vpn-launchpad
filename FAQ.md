# Frequently Asked Questions

- [Can I share VPN server with multiple local proxies?](#can-i-share-vpn-server-with-multiple-local-proxies)
- [What if vlp build command stalled with no response?](#what-if-vlp-command-stalled-with-no-response)
- [Can I build multiple VPN servers with the same AWS account?](#can-i-build-multiple-vpn-servers-with-the-same-aws-account)

## Can I share VPN server with multiple Pi boxes located in different networks?

Yes you can. `vlp --build` also saves shadowsocks connection parameters in VPN serever instance matadata. Hence all vpn-launchpad boxes configured with same AWS account and same region automaticly share the same VPN server instance.
- Initialise the 1st box via `vlp --init` with your Access Key ID and Secret Access Key
- Build a VPN server with 1st box with `vlp --build`
- Build a local proxy with 1st box with `lproxy --build`
- Initialise the 2nd box via `vlp --init` with the same Access Key ID and Secret Access Key used by the 1st box
- Build a local proxy with 2nd box with `lproxy --build`
- Done.


## What if vlp build command stalled with no response?

Stop it with Ctl-C then run "vlp --purge" to purge possible partially created VPN server.


## Can I build multiple VPN servers with the same AWS account?

Yes you can. But they must be located in different AWS region. Say: one in ap-northeast-1 and one in ap-northeast-2
