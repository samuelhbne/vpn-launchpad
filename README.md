# vpn-launchpad
Simple scripts for launching Amazon VPS with L2TP and Shadowsocks VPN running out of box


## Why vpn-launchpad?
With vpn-launchpad, you can:
 - Create VPN server on demand with the rate as low as $0.0058 per hour (t2.nano instance locate in Ohio) ATM.
 - Destory the server after using to avoid trail leaking as well as unnecessary cost.

## Running launchpad with/without Docker
###### What is Docker? In one line.
Docker is an application that helps setting up and isolating the environment for launchpad running.

###### Running launchpad with Docker:
vpn-launchpad provided a script that helps you building a container with all dependencies installed, then running launchpad from the container. Hence made it easy for user to run it without concerning about the dependencies installation like Python, pip, awscli, ssh etc. In this circumstance, Docker is the only dependency.

Instructions for running launchpad with Docker.

```
$ wget https://github.com/samuelhbne/vpn-launchpad/archive/master.zip
$ unzip master.zip
$ cd vpn-launchpad-master
$ ./docker-vlp.x64 
Sending build context to Docker daemon 5.632 kB
...
...
0  Init AWS credentials
1  Create VPN node on AWS
2  Check existing VPN server status...
3  Remove the existing VPN server from AWS
4  Exit vpn-launchpad

Please select:	 0
```
NOTE: Raspberry Pi user please run "docker-vlp.rspi" instead of "docker-vlp.x64"

###### Running launchpad directly:
If you are running Linux or Mac OSX and already got awscli, ssh, netcat and bash installed, you can also run launchpad directly without Docker. Launchpad will touch the AWS config from $HOME/.aws in this circumstance. So watch out if you have other applications that share the same configuration.

Instructions for running launchpad without Docker.

```
$ wget https://github.com/samuelhbne/vpn-launchpad/archive/master.zip
$ unzip master.zip
$ cd vpn-launchpad-master
$ ./vlp

0  Init AWS credentials
1  Create VPN node on AWS
2  Check existing VPN server status...
3  Remove the existing VPN server from AWS
4  Exit vpn-launchpad

Please select:	 0
```


## Docker installation
Linux (Ubuntu, Debian RHEL/CentOS or Raspberry Pi etc.), MacOSX or Windows 10 system with Docker installed is necessary for running launchpad with Docker
###### Docker installation for Ubuntu/Debian/Raspbian (for Raspberry Pi)
```
$ sudo apt-get update
$ sudo apt-get install docker.io
$ sudo usermod -aG docker `whoami`
$ exit
```
NOTE: You may need the following instructions to work around the "QoS" setting against <https://hub.docker.com> in China

```
$ sudo echo "DOCKER_OPTS=\"--registry-mirror=http://hub-mirror.c.163.com\"" >> /etc/default/docker
$ service docker restart
```
###### Docker installation for Mac OSX
<https://docs.docker.com/docker-for-mac/install/#what-to-know-before-you-install>
###### Docker installation for Windows
<https://docs.docker.com/docker-for-windows/install/>


## Dependency installation for running launchpad without Docker
Linux (Ubuntu, Debian RHEL/CentOS or Raspberry Pi etc.) or MacOSX system with ssh, nc and awsclii (Amazon Command line Interface) installed is necessary for running launchpad directly without Docker

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


## Initialize AWS credentials
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
PSK=YOUR-SHARED-SECRET
USERS=user0:pass0;user1:pass1;
SPW=SRV-MGT-PASS
HPW=HUB-MGT-PASS
```
Please refer softethervpn project for more details. All credits to Tomohisa Kusano:
<https://github.com/siomiz/SoftEtherVPN>


## What's the default port, password and encryption method of ShadowSocks VPN? How can I modify the  settings?
 - Modify the fields in docker-shadowsocks-libev/shadowsocks-libev.env accordingly.
 - Run vlp-purge to destroy existing VPN server instance if any.
 - Run vlp-build to create a new VPN server with updated login credential.

Here's what shadowsocks-libev.env looks like
```
SSPASS="YOUR-SHADOWSOCKS-PASS"
SSTCPPORT="8388"
SSUDPPORT="8388"
SSMETHOD="aes-256-cfb"
```

## What's the default port, uuid and encryption method of V2Ray vmess VPN? How can I modify the  settings?
 - Modify the fields in docker-v2rays/docker-v2rays.env accordingly.
 - Run vlp-purge to destroy existing VPN server instance if any.
 - Run vlp-build to create a new VPN server with updated login credential.

Here's what docker-v2rays.env looks like
```
VMESSPORT="9000"
UUID="5bef0493-f531-46fe-9713-c72255b22280"
ALTERID="32"
```
