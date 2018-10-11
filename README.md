# vpn-launchpad
Simple scripts for launching Amazon VPS with L2TP and Shadowsocks VPN running out of box


## Why vpn-launchpad?
With vpn-launchpad, you can:
 - Create VPN server on demand with the rate as low as $0.0058 per hour (t2.nano instance locate in Ohio) ATM.
 - Destory the server after using to avoid trail leaking as well as unnecessary cost.

## Running vpn-launchpad with Docker:
###### Why Docker?
For running vpn-launchpad without messing up the host environment with various applications which are necessary for vpn-launchpad running.
###### Docker installation for Ubuntu/Debian/Raspbian
```
$ sudo apt-get update
$ sudo apt-get install docker.io
$ sudo usermod -aG docker `whoami`
$ exit
```
###### Here for Docker installation on Mac OSX
<https://docs.docker.com/docker-for-mac/install/#what-to-know-before-you-install>
###### Here for Docker installation on Windows
<https://docs.docker.com/docker-for-windows/install/>
###### Running vpn-launchpad with Docker installed already:
Instructions for running vpn-launchpad via Docker on Ubuntu, MacOSX or Raspbian (Raspberry Pi 1,2,3).

```
$ git clone https://github.com/samuelhbne/vpn-launchpad
$ cd vpn-launchpad
$ ./docker-vlp
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


## Running vpn-launchpad without Docker (deprecated):
If you are running Linux or Mac OSX and already got awscli, ssh, netcat and bash installed, you can also run vpn-launchpad directly without Docker. Launchpad will touch the AWS config from $HOME/.aws in this circumstance. So watch out if you have other applications that share the same configuration.

Instructions for running vpn-launchpad without Docker.

```
$ git https://github.com/samuelhbne/vpn-launchpad
$ cd vpn-launchpad
$ ./vlp-menu

0  Init AWS credentials
1  Create VPN node on AWS
2  Check existing VPN server status...
3  Remove the existing VPN server from AWS
4  Exit vpn-launchpad

Please select:	 0
```


## Initialize AWS credentials
###### What is "AWS Access Key ID" and "AWS Secret Access Key":
Please following this link to initialize credential for AWS
<http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html>
###### What is "Default region name" and "Default output format"
No worries, just leave them as it is if have no idea.


## AWS free-tier user
Congrats, You can run the scripts out of the box if you are AWS free-tier user (First 12 month after new AWS account registeraion).


## Non-free tier AWS user
You might consider modifying the "INSTYPE" in vlp-build from "t2.micro" into "t2.nano" to half your AWS bill cost.


## How to connect to the newly created VPN server from MacOSX/Windows/Android/iOS via L2TP:
<https://www.softether.org/4-docs/2-howto/9.L2TPIPsec_Setup_Guide_for_SoftEther_VPN_Server>


## How to connect to the newly created VPN server from Linux/MacOSX/Windows/Android/iOS via ShadowSocks:
<https://shadowsocks.org/en/download/clients.html>


## What's the default username, password and pre-shared secret of L2TP VPN? How can I modify the  settings?
 - Modify USERS and PSK configurations in server-sevpn/sevpn.env please
 - Remove the existing VPN server if any and rebuild a new one from scratch.
 - New credentials should already be applied now.

Here's what server-sevpn/sevpn.env looks like
```
PSK=YOUR-SHARED-SECRET
USERS=user0:pass0;user1:pass1;
SPW=SRV-MGT-PASS
HPW=HUB-MGT-PASS
```
Please refer softethervpn project for more details. All credits to Tomohisa Kusano:
<https://github.com/siomiz/SoftEtherVPN>


## What's the default port, password and encryption method of ShadowSocks? How can I modify the  settings?
 - Modify the fields in server-ssserver/ssserver.env accordingly.
 - Remove the existing VPN server if any and rebuild a new one from scratch.
 - New credentials should already be applied now.

Here's what ssserver.env looks like
```
SSPASS="YOUR-SHADOWSOCKS-PASS"
SSMETHOD="aes-256-cfb"
SSTCPPORT="8388"
```

## How can I build local proxy to route all my traffic through the VPN server I built via vpn-launchpad?
proxy-build can do all the tedious works for you. It creates a local SOCKS/HTTP proxy as well as a local DNS server to free you fromDNS conatmination. Proxy configuration will be taken from the same configuration that built the remote VPS. Now change your browser proxy setting and enjoy.
```
$ ./proxy-build
...
Found VPS: 13.114.130.186

Checking local HTTP PROXY on TCP:58123 ...
curl -x http://127.0.0.1:58123 http://ifconfig.co
13.114.130.186

Checking local SOCKS PROXY on TCP:51080 ...
curl -x socks5://127.0.0.1:51080 http://ifconfig.co
13.114.130.186

Checking local DNS PROXY on UDP:55353 ...
dig +short @127.0.0.1 -p 55353 twitter.com
104.244.42.65

Done.
```

proxy-status prints the proxy status and the configuration details if it's running.
```
$ ./proxy-status
Local proxy found.

Checking local HTTP PROXY on TCP:58123 ...
curl -x http://127.0.0.1:58123 http://ifconfig.co
13.114.130.186

Checking local SOCKS PROXY on TCP:51080 ...
curl -x socks5://127.0.0.1:51080 http://ifconfig.co
13.114.130.186

Checking local DNS PROXY on UDP:55353 ...
dig +short @127.0.0.1 -p 55353 twitter.com
104.244.42.65

Done.
```

proxy-purge stops and removes the running proxy from local.
```
$ ./proxy-purge
Local proxy found. Purging...
sslocal
sslocal

Done.
```

###### How can I change the configuration of the local proxy?
Modify proxy-sslocal/sslocal.env as your wish. No worries for the VPN host, port, password or encryption method. proxy-build will generate them automaticlly from existing server-ssserver configuration.
```
# ignore this line, proxy-build will take care it
SSHOST=13.114.130.186

# SOCKS proxy listenning address
SOCKSADDR=0.0.0.0

# SOCKS proxy listenning port (TCP)
SOCKSPORT=51080

# HTTP proxy listenning port (TCP)
HTTPPORT="58123"

# DNS proxy listenning port (UDP)
DNSPORT="55353"
```
