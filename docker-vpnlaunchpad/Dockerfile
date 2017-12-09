FROM python:alpine

MAINTAINER Samuel Huang "samuelh2006@gmail.com"

ARG DKUID
ARG DKGID

ENV DKUID "$DKUID"
ENV DKGID "$DKGID"


RUN addgroup -g ${DKGID} ubuntu && adduser -G ubuntu -u ${DKUID} -s /bin/ash -h /home/ubuntu -D ubuntu
RUN apk update && apk add git openssh gcc musl-dev libffi-dev openssl-dev make bash

RUN su - ubuntu -c "pip install --user awscli azure-cli && echo 'export PATH=$PATH:~/.local/bin:~/bin/'>>.profile"
RUN su - ubuntu -c "mkdir .aws && echo -e '[default]\nregion = ap-northeast-1\noutput = json\n'>>.aws/config"


ADD run.sh /run.sh
RUN chmod 755 /*.sh
CMD ["/run.sh"]
