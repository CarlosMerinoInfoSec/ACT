#docker build -t act .

FROM ubuntu:20.04

LABEL maintainer="Carlos Merino contact@carlosmerino.org"

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /root

RUN apt-get update \
  && apt-get install -y nmap wget curl dnsutils python2 python3-pip python3-dev git vim unzip libcurl4-openssl-dev libssl-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip
  
ENV GOROOT=/usr/local/go
ENV PATH=$PATH:/usr/local/go/bin

ENTRYPOINT /bin/bash