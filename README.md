# Simple scripts for launching Amazon EC2 instances with L2TP server running out of the box

## Before we go
   A Linux system (Ubuntu, Debian RHEL/CentOS etc.) is necessary

## Amazon AWS command line interface installation on Ubuntu/Debian
   `$ sudo apt-get isnstall python-pip; pip install --user awscli`

## VPN Instance creation
   `$ sh zesty64-create.sh`

## VPN Instance deletion
   `$ sh zesty64-delete.sh`

## VPN user management
   Modify the "USERS" section in docker-sevpn/sevpn.env
   `USERS=user0:pass0;user1:pass1;`
