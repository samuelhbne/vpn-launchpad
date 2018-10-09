FROM arm32v6/alpine

MAINTAINER Samuel Huang "samuelh2006@gmail.com"

RUN apk update && apk add git openssh gcc musl-dev libffi-dev openssl-dev make bash py-pip

RUN pip install awscli

ENV HOME "/vpn-launchpad"
