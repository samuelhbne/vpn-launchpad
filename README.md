# vpn-launchpad
Simple scripts for launching Amazon VPS with L2TP and Shadowsocks VPN running out of box


## Why vpn-launchpad?
With vpn-launchpad, you can:
 - Create VPN server on demand with the rate as low as $0.0058 per hour (t2.nano instance locate in Ohio) ATM.
 - Destory the server after using to avoid trail leaking as well as unnecessary cost.

## Script Runner and Container Runner
vpn-launchpad provided two different ways for running.
###### Script Runner:
For Linux and Mac user only. Needs Amazon awscli, ssh, netcat first as dependencies. Please run the following command to start Script Runner

```
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad
$ ./vlp
0     Init AWS credentials
1     Create VPN node on AWS
2     Check existing VPN server status...
3     Remove the existing VPN server from AWS
Other Exit vpn-launchpad

Please select:	
```
###### Container Runner:
For Linux, Mac and Windows 10 user. Needs Docker as dependency. It could be an easier way in most circumstances. Please run the following command to start Container Running. Raspberry Pi users please run "docker-vlp.rspi" instead of "docker-vlp.x64"

```
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad
$ ./docker-vlp.x64 
Sending build context to Docker daemon 5.632 kB
...
...
0  Init AWS credentials
1  Create VPN node on AWS
2  Check existing VPN server status...
3  Remove the existing VPN server from AWS
4  Exit vpn-launchpad

Please select:	
```

## Prerequisites for Script Running
A Linux system (Ubuntu, Debian RHEL/CentOS or Raspberry Pi etc.) or MacOSX system with ssh, nc and awsclii (Amazon Command line Interface) installed  is necessary for Script Running

###### Instructions for dependency installation on Ubuntu/Debian/RaspberryPi Linux
```
$ sudo apt-get update
$ sudo apt-get install python-pip ssh netcat bash
$ pip install awscli --upgrade --user
$ echo 'export PATH=$PATH:~/.local/bin' >>.bashrc 
$ export PATH=$PATH:~/.local/bin
$ aws --version
aws-cli/1.11.161 Python/2.7.13 Linux/4.12.1-kirkwood-tld-1 botocore/1.7.19
```

###### Instructions for awscli installation on MacOSX10
```
$ curl -O https://www.python.org/ftp/python/3.6.3/python-3.6.3-macosx10.6.pkg
$ sudo installer -pkg python-3.6.3-macosx10.6.pkg -target /
$ curl -O https://bootstrap.pypa.io/get-pip.py
$ python3 get-pip.py
$ pip3 install --user awscli
```
###### Following this link to config credential for awscli
<http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html>


## Prerequisites for Container Running
Linux (Ubuntu, Debian RHEL/CentOS or Raspberry Pi etc.), MacOSX or Windows 10 system with Docker installed is necessary for Container Runner
###### Instructions for dependency installation on Ubuntu/Debian/RaspberryPi Linux
```
$ sudo apt-get update
$ sudo apt-get install docker.io
$ sudo usermod -aG docker `whoami`
$ exit
```

## Init AWS credentials
###### What is "AWS Access Key ID" and "AWS Secret Access Key":
Please following this link to initialize credential for AWS
<http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html>
###### What is "Default region name" and "Default output format"
No worries, just leave them as it was if have no idea.


## AWS free-tier user
If you are AWS free-tier user (First 12 month after your AWS account registeraion). You can run the scripts out off the box after filling ~/.aws/credential with your credential. Follow this guider please for more details:
<http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html>


## Non-free tier AWS user
Please modify the "INSTYPE" field in vlp-build from "t2.micro" into "t2.nano" to half your hourly rate.


## How to connect to the newly created VPN server from MacOSX/Windows/Android/iOS via L2TP:
<https://www.softether.org/4-docs/2-howto/9.L2TPIPsec_Setup_Guide_for_SoftEther_VPN_Server>


## How to connect to the newly created VPN server from Linux/MacOSX/Windows/Android/iOS via ShadowSocks:
<https://shadowsocks.org/en/download/clients.html>


## What's the default username, password and pre-shared secret of L2TP VPN? How can I modify the  settings?
 - Modify USERS and PSK configurations in docker-sevpn/sevpn.env please
 - Run vlp-purge to destroy existing VPN server instance if any
 - Run vlp-build to create a new VPN server with updated login credential.

Here's what docker-sevpn/sevpn.env looks like
```
$ cat docker-sevpn/sevpn.env
PSK=YOUR-SHARED-SECRET
USERS=user0:pass0;user1:pass1;
SPW=SRV-MGT-PASS
HPW=HUB-MGT-PASS
```
Please refer softethervpn project for more details. All credits to Tomohisa Kusano:
<https://github.com/siomiz/SoftEtherVPN>


## What's the default port, password and encryption method of ShadowSocks VPN? How can I modify the  settings?
 - Modify the fields in docker-shadowsocks-libev/shadowsocks-libev.sh accordingly.
 - Run vlp-purge to destroy existing VPN server instance if any.
 - Run vlp-build to create a new VPN server with updated login credential.

Here's the sample configuration in shadowsocks-libev.sh
```
$ head -n7 shadowsocks-libev.sh|grep =
SSPASS="YOUR-SHADOWSOCKS-PASS"
SSTCPPORT="8388"
SSUDPPORT="8388"
SSMETHOD="aes-256-cfb"
```
