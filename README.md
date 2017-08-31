# Simple scripts for launching Amazon EC2 instances with L2TP VPN server running out of the box

## Prerequisites
A Linux system (Ubuntu, Debian RHEL/CentOS etc.) is necessary

## Amazon AWS command line interface installation on Ubuntu/Debian
`$ sudo apt-get isnstall python-pip; pip install --user awscli`

## Server Instance creation
`$ sh zesty64-create.sh`

## Server Instance deletion
`$ sh zesty64-delete.sh`

## VPN user management
Modify the "USERS" section in docker-sevpn/sevpn.env before server instance creation
```
USERS=user0:pass0;user1:pass1;
```
