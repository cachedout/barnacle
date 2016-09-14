FROM ubuntu:14.04

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt

RUN apt-get update
RUN apt-get -y install wget python-pip python-dev openssl openssl-dev
RUN wget -O - https://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -

COPY saltstack.list /etc/apt/sources.list.d/saltstack.list

RUN apt-get update

RUN apt-get -y install salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api

RUN pip install --upgrade pip
RUN pip install -r /dev_python27.txt

VOLUME /testing
