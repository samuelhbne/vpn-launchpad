FROM ubuntu
VOLUME /opt/
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | tee /etc/apt/sources.list.d/azure-cli.list
#RUN apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
#RUN apt-get install -y apt-transport-https
#RUN apt-get update && apt-get install -y azure-cli

# RUN apt-get install -y git
