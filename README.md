# VPN Launchpad

EC2 VPN server builder with multiple VPN support including L2TP, Shadowsocks, V2ray, Brook and Trojan.

Works in Ubuntu(Xenial and above), Mac OSX(Yosemite and above) and Debian(Buster and above) variants including Raspbian. Running in Windows with dind (Docker in docker) container is possible, but not yet verified.

## How it works

Command vlp creates EC2 instance with VPN services installed out of box. Command lproxy creates proxy (SOCKS/HTTP/DNS) container running locally on your PC, Mac or Raspberry Pi, which tunneling all traffic through the VPN server on EC2. AWS account ID/key are necessary.

## Quick start on Ubuntu / Debian(Buster) / Raspbian

### 1. Dependencies installation

```console
$ sudo apt-get update; sudo apt-get install docker.io git dnsutils curl whois
...
$ sudo usermod -aG docker `whoami`; exit
```

Note: It is necessary to log out current session and back to get docker group setting take effect.

Note: For Raspberry Pi users, please update to Raspbian Buster before Docker installation as Docker version earlier than 18.09 is not supported any more.

### 2. Initialize AWS credential and VPN server region

```console
$ git clone https://github.com/samuelhbne/vpn-launchpad.git
$ cd vpn-launchpad
$ ./vlp init
AWS Access Key ID [None]: INPUT-YOUR-AWS-ID-HERE
AWS Secret Access Key [None]: INPUT-YOUR-AWS-KEY-HERE
Default region name [ap-northeast-1]:
Default output format [json]:
Done.
$
```

Note: './vlp init' need to download docker image(about 100MB) during the 1st time execution. However hub.docker.com might be 'throttled' mysteriously in certain country. Please try './vlp --from-src init' instead to build the docker image from source in case './vlp init' stuck on downloading over 10 minutes without progress.

### 3. Build VPN server on AWS

```console
$ ./vlp build --without-random --with-sslibev
...
Shadowsocks-URI: ss://YWVzLTI1Ni1nY206U1NTTElCRVYtUEFTUw==@13.231.224.253:28388#VLP-shadowsocks
...
Scan QR code above from Shadowsocks compatible mobile app to connect your mobile phone/tablet.
Done.
$
```

![QR code example](https://github.com/samuelhbne/vpn-launchpad/blob/master/images/qr.png)

### 4. Connect from your mobile phone

Scan the QR code generated above from Shadowsocks compatible mobile app ([Shadowrocket](https://itunes.apple.com/au/app/shadowrocket/id932747118) for iOS or [Shadowsocks](https://github.com/shadowsocks/shadowsocks-android/releases) for Android etc.) to connect your mobile phone/tablet and enjoy.

### 5. Build local proxy on Ubuntu / Debian(Buster) / Raspbian [optional]

Please jump to step 8 if PC/Mac browser connection is not your goal.

```console
$ ./lproxy build v2ray
...
Setting up local proxy daemon...
Done.

Starting up local proxy daemon...
Done.

Wait 15s for local proxy initialisation...
Done.

Local proxy is running.

VPN sever address: 13.231.224.253

Checking SOCKS5 proxy on 127.0.0.1:1080 TCP ...
curl -sSx socks5h://127.0.0.1:1080 http://ifconfig.co
13.231.224.253
SOCKS5 proxy check passed.

Checking HTTP proxy on 127.0.0.1:8123 TCP ...
curl -sSx http://127.0.0.1:8123 http://ifconfig.co
13.231.224.253
HTTP proxy check passed.

Checking DNS server on 127.0.0.1:65353 UDP ...
dig +short @127.0.0.1 -p 65353 twitter.com
104.244.42.1
104.244.42.193
Checking 104.244.42.1 IP owner ...
docker exec -it proxy-sslibev whois 104.244.42.1|grep OrgId
OrgId:          TWITT
DNS server check passed.

Done.
$
```

Note: './lproxy build' need to download docker image(about 90MB) during the 1st time execution. However hub.docker.com might be 'throttled' mysteriously in certain country. Please try './lproxy build --from-src' instead to build the docker image from source in case './lproxy build' stuck on downloading over 10 minutes without progress.

### 6. Browser configuration [optional]

Now modify connnection settings for [Firefox](https://support.mozilla.org/en-US/kb/connection-settings-firefox), [Safari](https://support.apple.com/en-au/guide/safari/set-up-a-proxy-server-ibrw1053/mac) or [Chrome](https://www.expressvpn.com/support/troubleshooting/google-chrome-no-proxy/) according to the proxy port settings given above.

### 7. Stop and remove local proxy container from Pi box after surfing [optional]

```console
$ ./lproxy purge
Local proxy found. Purging...
Done.
$
```

### 8. Terminate VPN server instance from AWS after surfing

```console
$ ./vlp purge
...
Waiting Instance shutdown...
Done.

Removing Security Group of vlp-bionic...
Security Group Removed.

Deleting SSH Key-Pair of vlp-bionic...
Done.
$
```

Note: Terminating VPN server instance from AWS after surfing is always recommended. It removes the potential trails from cloud to protect your privacy as well as reduces the cost for AWS service hiring in case you are not AWS free tier user.

## Quick tour for getting AWS account ID and key

1. Create an new AWS free account [here](https://aws.amazon.com/) if you don't have. I'm not affiliate.
2. Login into [AWS IAM console](https://console.aws.amazon.com/iam/) with your account.
3. Click "User" from left side then click "Add user" button on the top
4. Input the "User name" and tick "Programmatic access" box below
5. Click "Next: Permissions" button
6. Click "Create group" button
7. Fill "Group name" with "vlpadmin" and tick "AmazonEC2FullAccess" selection box which on the top of the policy list
8. Click "Create group" blue button at the bottom right of the page.
9. Tick the "vlpadmin" selection box in "Add user to group" page
10. Click "Next: Tags", click "Next: Review" then click "Create user" button
11. Click "Show" link
12. Now you get the "Access key ID" and "Secret access key" that necessary for vpn-launchpad running

Follow the [official AWS doc page](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) for more details

## Full command Usage

### VPN server management

```console
$ ./vlp
vlp [--from-src] <command> [options]
  --from-src            -- Build dependency container from source rather than docker image downloading
    init                -- Init aws account credential.
    build               -- Build VPN server.
      --from-src        -- Build VPN server from source rather than docker image downloading
      --with-brook      -- Build VPN server with Brook services installed
      --with-l2tp       -- Build VPN server with L2TP services installed
      --with-v2ray      -- Build VPN server with V2Ray services installed
      --with-trojan     -- Build VPN server with Trojan services installed
      --with-sslibev    -- Build VPN server with Shadowsocks services installed
      --with-random     -- Build VPN server with VPN passwords randomisation.
      --without-random  -- Build VPN server without VPN passwords randomisation.
    status              -- Check VPN server status.
      --with-qrcode     -- Print Shadowsocks and V2Ray connection QR Code.
    purge               -- Destory VPN server instance.
    random              -- Randomise VPN passwords.
    ssh                 -- SSH login into VPN server instance.
```

### Local proxy management

```console
$ ./lproxy
lproxy <command> [options]
  build            -- Build local proxy container.
    --from-src     -- Build local proxy container from source rather than docker image downloading.
      brook        -- Build local proxy container that connect to VPN server via Brook connector
      sslibev      -- Build local proxy container that connect to VPN server via Shadowsocks connector
      trojan       -- Build local proxy container that connect to VPN server via Trojan connector
      v2ray        -- Build local proxy container that connect to VPN server via V2ray connector
  status           -- Check local proxy container status.
  purge            -- Destory local proxy container.
```

Note: Please build VPN server before local proxy building.

Note: Component depency fetching from golang.org is necessary during the progress of building v2ray/brook with '--from-src' switch. However, golang.org access might be blocked in cetain country hence lead to the consequent building failure. Please remove '--from-src' switch (which means build from docker hub images fetching) if that is your case.

## VPN server configuration

### Password, encryption method and listening port configuration for Shadowsocks server

```console
$ cat server-sslibev/server-sslibev.env
SGTCP="28388"
SGUDP="28388"
SSPORT="28388"
SSPASS="SSSLIBEV-PASS"
SSMTHD="aes-256-gcm"
$
```

NOTE: Please ensure SGTCP/SGUDP and SSPORT are the same value to guarantee that AWS enabled the specific TCP/UDP port for incoming connection which server-sslibev service listened.

NOTE: Please run './vlp purge; ./vlp build' to get the new Shadowsocks server configuration applied.

Credits to [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev)

### UUID, V2RAYAID, V2RAYLEVEL configuration for V2Ray server

```console
$ cat server-v2ray/server-v2ray.env
SGTCP="10086"
V2RAYPORT="10086"
V2RAYUUID="2633f6b5-0032-4f9e-ae1d-c21d9010cd27"
V2RAYLEVEL="1"
V2RAYAID="64"
$
```

NOTE: Please ensure SGTCP/SGUDP and V2RAYPORT are the same value to guarantee that AWS enabled the specific TCP/UDP port for incoming connection which server-v2ray service listened.

NOTE: Please run './vlp purge; ./vlp build' to get the new V2Ray server configuration applied.

Credits to [V2Ray](https://github.com/V2Ray/v2ray-core)

### Fake domain, Duckdns domain, Duckdns token, Trojan password configuration for Trojan server

```console
$ cat server-trojan/server-trojan.env
SGTCP="443:8443"
TRJPORT="443"
TRJPASS="TROJAN_PASSWORD"
TRJFAKEDOMAIN="www.microsoft.com"
DUCKDNSTOKEN="6ad424a4-1cc3-4cf7-87ec-0f61ce2c9416"
DUCKDNSDOMAIN="myduckdomain"
DUCKSUBDOMAINS="wildcard"
$
```

NOTE: You need to register a free domain name on duckdns.org first.

NOTE: Please replace DUCKDNSTOKEN with the token obtained from the top of your duckdns.org home page after login.

NOTE: Please replace DUCKDNSDOMAIN with the domain name you registered on duckdns.org.

NOTE: Please run './vlp purge; ./vlp build' to get the new Trojan server configuration applied.

Credits to [Trojan](https://github.com/trojan-gfw/trojan)

### Username, password and pre-shared secret configuration for Softether L2TP server

```console
$ cat server-softether/server-softether.env
...
PSK=YOUR-SHARED-SECRET
USERS=user0:pass0;user1:pass1;
...
$
```

NOTE: Please run './vlp purge && ./vlp build' to get the new L2TP server configuration applied.

Credits to [Tomohisa Kusano](https://github.com/siomiz/SoftEtherVPN) and [SoftEtherVPN](https://github.com/SoftEtherVPN/SoftEtherVPN)

## Local proxy configuration

### SOCKS/HTTP/DNS port for local proxy

```console
$ cat proxy-sslibev/proxy-sslibev.env
SOCKSPORT="1080"
HTTPPORT="8123"
DNSPORT="65353"
$
```

NOTE: Please run './lproxy build' to get the new Shadowsocks client configuration applied.

Credits to [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev)

## Before running

Docker installation is necessary for running vlp and lproxy. curl and dig will be used by 'lproxy status' for connection test and diagnosis but not compulsory.

### Dependencies installation for Ubuntu / Debian(Buster) / Raspbian

```console
$ sudo apt-get update; sudo apt-get install docker.io git dnsutils curl whois
...
$ sudo usermod -aG docker `whoami`; exit
```

### Docker installation for Mac OSX

<https://store.docker.com/editions/community/docker-ce-desktop-mac>

## Connect to the VPN server via Shadowsocks/V2Ray/Trojan protocol from mobile devices

Both "vlp build" and "vlp status --with-qrcode" spit QR codes (for Shadowsocks, V2Ray and Trojan) to facilitate the connection from mobile devices via QR supported app like [Shadowrocket](https://itunes.apple.com/au/app/shadowrocket/id932747118) for iOS, or [Shadowsocks](https://github.com/shadowsocks/shadowsocks-android/releases), [v2rayNG](https://play.google.com/store/apps/details?id=com.v2ray.ang) and [Igniter](https://github.com/trojan-gfw/igniter/releases) (QR code scanning is unavailable so far) for Android. Simply scanning the QR code from these apps will create a new connection entry. Connect to it and Enjoy.
![QR code example](https://github.com/samuelhbne/vpn-launchpad/blob/master/images/qr.png)

All credits to [qrcode-terminal](https://www.npmjs.com/package/qrcode-terminal)

## Connect to the VPN server via L2TP

<https://www.softether.org/4-docs/2-howto/9.L2TPIPsec_Setup_Guide_for_SoftEther_VPN_Server>

## Cleaning Before upgrading

Image/container names may changed after upgrading. Please do the following before upgrading:

1. purge VPN server(s) and local proxy container you previously created via 'vlp' and 'lproxy';
2. Stop and remove existing vpnlaunchpad and lproxy containers;
3. Remove existing vpnlaunchpad and lproxy images.

Please follow the instructions here to do the cleaning:

```console
$ ./vlp purge
...
$ ./lproxy purge
...
$ docker stop `docker ps -a|grep samuelhbne|awk '{print $1}'`
$ docker rm `docker ps -a|grep samuelhbne|awk '{print $1}'`
$ docker rmi `docker images |grep samuelhbne|awk '{print $3}'`
```

## Running in dind (Docker in Docker) container

It is possible to run vpn-launchpad in dind container if Ubuntu is not your option. The following instructions will start a dind container with necessary local proxy port mappings, install package dependencies inside the container, create a non-root user with docker service access, and start vlp/lproxy consiquently.

```console
$ docker run --privileged --name vlpdind -p 1080:1080 -p 8123:8123 -p 65353:65353 -d docker:stable-dind
$ docker exec -it vlpdind sh
/ # apk add bash shadow git curl bind-tools whois
/ # adduser -s /bin/bash -D vlp
/ # usermod -aG root vlp
/ # su - vlp
72d645e47cb2:~$ git clone https://github.com/samuelhbne/vpn-launchpad
72d645e47cb2:~$ cd vpn-launchpad/
72d645e47cb2:~/vpn-launchpad$ ./vlp init
72d645e47cb2:~/vpn-launchpad$ ./vlp build --without-random --with-v2ray
72d645e47cb2:~/vpn-launchpad$ ./lproxy build v2ray
...
```

## FAQ

[Frequently Asked Questions](FAQ.md)
