FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl
RUN /usr/bin/curl -L -s https://install.direct/go.sh | /bin/bash

ADD server.json /etc/v2ray/server.json
ADD run.sh /run.sh
RUN chmod 755 /*.sh

EXPOSE 8000
CMD ["/run.sh"]
