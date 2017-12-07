FROM ubuntu:16.04

MAINTAINER Samuel Huang "samuelh2006@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y git python-pip ssh netcat
RUN groupadd -g 1000 ubuntu && adduser --disabled-password --uid 1000 --gid 1000 ubuntu --home /home/ubuntu

RUN su - ubuntu -c "pip install --user awscli azure-cli && echo 'export PATH=$PATH:~/.local/bin:~/bin/'>>.bashrc"
RUN su - ubuntu -c "mkdir .aws && echo -e '[default]\nregion = ap-northeast-1\noutput = json\n'>>.aws/config"
RUN su - ubuntu -c "git clone -b launch-from-docker https://github.com/samuelhbne/vpn-launchpad"


ADD run.sh /run.sh
RUN chmod 755 /*.sh
CMD ["/run.sh"]


