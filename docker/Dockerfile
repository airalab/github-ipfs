FROM airalab/ipfs-cloud 
MAINTAINER Alexander Krupenkin <mail@akru.me>
LABEL Description="GitHub -> IPFS mirror bot" Vendor="Airalab" Version="0.1"

RUN apt-get update && apt-get install -y curl git 
RUN curl -SSl https://get.haskellstack.org/ | sh
RUN apt-get autoclean

RUN git clone --recursive https://github.com/airalab/github-ipfs
RUN cd /github-ipfs && stack setup && stack install
RUN mv /root/.local/bin/github-ipfs /usr/local/bin

RUN rm -rf /github-ipfs /root/.stack /root/.local

ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
