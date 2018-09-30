FROM python:alpine

MAINTAINER Samuel Huang "samuelh2006@gmail.com"

ARG DKUID
ARG DKGID

ENV DKUID "$DKUID"
ENV DKGID "$DKGID"

# Work around with gid conflict between OSX and Alpine
# MacOSX: gid=20(staff)
# Alpine: gid=20(dialout)

RUN if [ "$(getent group ${DKGID}|cut -d":" -f1)" == "" ]; then addgroup -g ${DKGID} ubuntu; fi
RUN adduser -G `getent group ${DKGID}|cut -d":" -f1` -u ${DKUID} -s /bin/ash -h /home/ubuntu -D ubuntu
RUN apk update && apk add git openssh gcc musl-dev libffi-dev openssl-dev make bash

RUN su - ubuntu -c "pip install --user awscli && echo 'export PATH=$PATH:~/.local/bin:~/bin/'>>.profile"

ENTRYPOINT ["su", "-", "ubuntu", "-c"]
CMD ["'vpn-launchpad/vlp-menu'"]
