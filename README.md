# vpn-launchpad
Simple scripts for launching Amazon EC2 instances with L2TP VPN server running out of the box

## Why vpn-launchpad?
With vpn-launchpad, you can:
 - Create a L2TP server instance on demand with the rate as low as $0.0059 per hour ATM.
 - Delete the server instance after using to avoid unnecessary cost.

## Prerequisites
A Linux system (Ubuntu, Debian RHEL/CentOS etc.) or MacOSX system with ssh, nc and awsclii (Amazon Command line Interface) installed  is necessary for vpn-launchpad running

Instructions for awscli installation on Ubuntu/Debian
```
$ sudo apt-get update
$ sudo apt-get install python-pip
$ pip install awscli --upgrade --user
$ ~/.local/bin/aws --version
aws-cli/1.11.161 Python/2.7.13 Linux/4.12.1-kirkwood-tld-1 botocore/1.7.19
```
Credential setup for awscli
<http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html>

## How to create VPN server:
`$ sh zesty64-create.sh`

## How to remove the existing VPN server instance and the resources associated:
`$ sh zesty64-delete.sh`

## How can I change the VPN connection login credentials? L2TP Username, password, preshared secret, etc:
 - Modify docker-sevpn/sevpn.env
 - Run zesty64-delete.sh to destroy existing VPN server instance if any
 - Run zesty64-create.sh to create a new VPN server with the updated L2TP login credential.
Here's what the sevpn.env looks like
```
$ cat docker-sevpn/sevpn.env
PSK=YOUR-SHARED-SECRET
USERS=user0:pass0;user1:pass1;
SPW=SRV-MGT-PASS
HPW=HUB-MGT-PASS
```
Please refer softethervpn project for more details. All credits to Tomohisa Kusano:
<https://github.com/siomiz/SoftEtherVPN>

## How to setup L2TP client on iPhone, Android, Linux, Mac or Windows:
<https://www.softether.org/4-docs/2-howto/9.L2TPIPsec_Setup_Guide_for_SoftEther_VPN_Server>
