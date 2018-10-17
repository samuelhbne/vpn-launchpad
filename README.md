# VPN Launchpad

Turn your Raspberry Pi box into a VPN tunnel proxy (HTTP/SOCKS) within minutes. All you need is an Amazon AWS account. Also works with Debian, Ubuntu (16.04 and above) or Mac OSX.



## How it works

Command vlp creates/purges VPN server with the AWS account provided. Command lproxy creates/purges a proxy running locally with SOCKS/HTTP/DNS support, which tunneling all traffic through the VPN server previously created by command vlp.



## Get AWS account ID and key
<http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html>



## Usage

./vlp [options]
* --init        -- Init with aws account credential.
* --build       -- Build a new VPS with VPN services (Shadowsocks/L2TP) installed out of box.
* --query       -- Query the current VPS status.
* --purge       -- Purge the VPS built previously.

./lproxy [options]
* --build         -- Build a proxy server running localy on Pi box with SOCKS, HTTP and DNS support.
* --status        -- Check the proxy server running status and the proxy settings.
* --purge         -- Purge the running proxy server from Pi box.
Note: A VPS must be built first before local proxy building.



## Quick start on Raspbian or Ubuntu

#### Dependencies installation
```
$ sudo apt-get update; sudo apt-get install docker.io dnsutils curl
$ sudo usermod -aG docker `whoami`; exit
```
#### AWS account set up
```
$ git clone https://github.com/samuelhbne/vpn-launchpad; cd vpn-launchpad
$ ./vlp --init
AWS Access Key ID [None]: INPUT-YOUR-AWS-ID-HERE
AWS Secret Access Key [None]: INPUT-YOUR-AWS-KEY-HERE
Default region name [ap-northeast-1]: 
Default output format [json]: 
```

#### VPN server build up
```
$ ./vlp --build
...
New VPN server Instance is up on 13.231.224.253
Enjoy.
```

#### Local proxy build up
```
$ ./lproxy --build
...
Found VPS: 13.231.224.253
Checking local HTTP PROXY on TCP:58123 ...
curl -x http://127.0.0.1:58123 http://ifconfig.co
13.231.224.253

Checking local SOCKS PROXY on TCP:51080 ...
curl -x socks5://127.0.0.1:51080 http://ifconfig.co
13.231.224.253

Checking local DNS PROXY on UDP:55353 ...
dig +short @127.0.0.1 -p 55353 twitter.com
104.244.42.65
104.244.42.193

Done.
```

#### Browser configuration
Now modify connnection settings for [Firefox](https://support.mozilla.org/en-US/kb/connection-settings-firefox), [Safari](https://support.apple.com/en-au/guide/safari/set-up-a-proxy-server-ibrw1053/mac) or [Chrome](https://www.expressvpn.com/support/troubleshooting/google-chrome-no-proxy/) according to the proxy port settings given above.



## Configuration

#### Username, password and pre-shared secret for L2TP VPN.
```
$ cat server-softether/softether.env
PSK=YOUR-SHARED-SECRET
USERS=user0:pass0;user1:pass1;
```
All credits to [Tomohisa Kusano](https://github.com/siomiz/SoftEtherVPN) and [SoftEtherVPN](https://github.com/SoftEtherVPN/SoftEtherVPN)


#### Password, encryption method and listening port for ShadowSocks.
```
$ cat server-ssserver/ssserver.env
SSPASS="YOUR-SHADOWSOCKS-PASS"
SSMETHOD="aes-256-cfb"
SSTCPPORT="8388"
```
NOTE: VPS purging and re-creation are necessary for getting new configuration applied.

#### SOCKS/HTTP/DNS port for local proxy
```
$ cat proxy-sslocal/sslocal.env 
SOCKSPORT="51080"
HTTPPORT="58123"
DNSPORT="55353"
```
NOTE: Local proxy purging and re-creation will be necessary to get the new configuration applied.



## Before running

Docker is necessary for vpn-launchpad. curl and dig will be used for local proxy testing but not compulsory.

#### Docker installation for Raspbian or Ubuntu
```
$ sudo apt-get update; sudo apt-get install docker.io
$ sudo usermod -aG docker `whoami`; exit
```
#### Docker installation for Mac OSX
<https://docs.docker.com/docker-for-mac/install/#what-to-know-before-you-install>



## Connect to the VPS server via L2TP:
<https://www.softether.org/4-docs/2-howto/9.L2TPIPsec_Setup_Guide_for_SoftEther_VPN_Server>



## Connect to the VPS server via ShadowSocks:
<https://shadowsocks.org/en/download/clients.html>
