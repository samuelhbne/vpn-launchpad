# vpn-launchpad
Simple scripts for launching Amazon EC2 instances with L2TP VPN server running out of the box

## Why vpn-launchpad?
With vpn-launchpad, you can:
 - Create a L2TP server instance on demand with the rate as low as $0.0059 per hour ATM.
 - Delete the server instance after using to avoid unnecessary cost.

## Prerequisites
A Linux system (Ubuntu, Debian RHEL/CentOS etc.) is necessary

Amazon AWS command line interface installation on Ubuntu/Debian
```
$ sudo apt-get update
$ sudo apt-get isnstall python-pip
$ pip install awscli --upgrade --user
```

Credential setup for AWS cli

<http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html>


## How to create VPN server:
`$ sh zesty64-create.sh`

## How to remove the existing VPN server instance and the resources associated:
`$ sh zesty64-delete.sh`

## How can I change the VPN connection credentials? Username, password, preshared secret, etc:
Please modify docker-sevpn/sevpn.env, run zesty64-delete.sh to destroy the existing instance then run zesty64-create.sh to create a new instance with newly updated credential configuration. Please refer softethervpn project for more details. All credits to Tomohisa Kusano:
<https://github.com/siomiz/SoftEtherVPN>
```
$ cat docker-sevpn/sevpn.env
PSK=YOUR-SHARED-SECRET
USERS=user0:pass0;user1:pass1;
SPW=SRV-MGT-PASS
HPW=HUB-MGT-PASS
```

## How to setup clients:
<https://www.softether.org/4-docs/2-howto/9.L2TPIPsec_Setup_Guide_for_SoftEther_VPN_Server>
