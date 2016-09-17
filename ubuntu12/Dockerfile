FROM ubuntu:12.04

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt

RUN apt-get update
RUN apt-get -y install wget python-pip gcc python-dev
# FIXME --no-check-certiicate isn't work. Disabled SSL!
RUN wget -O - http://repo.saltstack.com/apt/ubuntu/12.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -

COPY saltstack.list /etc/apt/sources.list.d/saltstack.list

RUN apt-get update

# Install Salt packages
RUN apt-get -y install salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api

# Install other helpful packages
RUN apt-get -y install vim

RUN pip install --upgrade pip
RUN pip install -r /dev_python27.txt

VOLUME /testing
