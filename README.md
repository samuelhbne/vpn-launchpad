# VPN Launchpad

Turn your Raspberry Pi (1/2/3/zero) into a VPN proxy (HTTP/SOCKS/DNS) that tunnels all traffic through AWS EC2. All you need is an Amazon AWS account for EC2 VPN server creation.

Also works on Ubuntu (16.04 and above), Mac OSX or Debian.



## How it works

Command vlp creates/purges VPN server via AWS EC2 service. Command lproxy creates/purges a proxy (SOCKS/HTTP/DNS) running locally, which tunneling all traffic through the VPN server previously created by command vlp.



## Quick tour for getting AWS account ID and key
1. Create an new AWS free account [here](https://aws.amazon.com/) if you don't have. I'm not affiliate.
2. Login into [AWS IAM console](https://console.aws.amazon.com/iam/) with your account.
3. Click "User" on the left side then click "Add user" button on the top
4. Choose the "User name" and tick "Programmatic access" box below
5. Click "Next: Permissions" button
6. Tick the "admin" box in "Add user to group" page
7. Click "Next: Review" then click "Create user" button
8. Click "Show" link
9. Now you get the "Access key ID" and the "Secret access key" that are necessary for vpn-launchpad running

Follow the [official doc page](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) for more details



## Usage

./vlp [options]
* --init        -- Init aws account credential.
* --build       -- Build new VPN server.
* --query       -- Query VPN server status.
* --purge       -- Purge existing VPN server.

./lproxy [options]
* --build         -- Build local proxy server.
* --status        -- Check local proxy server status.
* --purge         -- Purge existing local proxy.

Note: A VPN server should have been built before local proxy building.



## Quick start on Raspbian or Ubuntu

#### 1. Dependencies installation
```
$ sudo apt-get update; sudo apt-get install docker.io dnsutils curl
$ sudo usermod -aG docker `whoami`; exit
```
Note: It is necessary to log out current session and back to get docker group setting take effect.

#### 2. AWS account set up
```
$ git clone https://github.com/samuelhbne/vpn-launchpad; cd vpn-launchpad

$ ./vlp --init
AWS Access Key ID [None]: INPUT-YOUR-AWS-ID-HERE
AWS Secret Access Key [None]: INPUT-YOUR-AWS-KEY-HERE
Default region name [ap-northeast-1]: 
Default output format [json]: 
```

#### 3. VPN server build up
```
$ ./vlp --build
...
New VPN server Instance is up on 13.231.224.253
Enjoy.
```

#### 4. Local proxy build up
```
$ ./lproxy --build
...
Tunnel VPS: 13.231.224.253
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

#### 5. Browser configuration
Now modify connnection settings for [Firefox](https://support.mozilla.org/en-US/kb/connection-settings-firefox), [Safari](https://support.apple.com/en-au/guide/safari/set-up-a-proxy-server-ibrw1053/mac) or [Chrome](https://www.expressvpn.com/support/troubleshooting/google-chrome-no-proxy/) according to the proxy port settings given above.

#### 6. Purge local proxy after the end of surfing
```
$ ./lproxy --purge
```

#### 7. Purge VPN server from AWS
```
$ ./vlp --purge
```

Note: Purging the local proxy and the VPN server from cloud after the end of surfing is always recommended. Not only it reduces the cost of AWS service hiring in case you are not a free tier user, but also it purges the surfing trail from cloud hence protects your privacy.


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

Docker is necessary for running vlp and lproxy. curl and dig will be used for lproxy verification after local proxy building but not compulsory.

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
