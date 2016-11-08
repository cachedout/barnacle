FROM debian:jessie

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt

RUN apt-get update
RUN apt-get -y install wget python-pip python-dev
RUN wget -O - https://repo.saltstack.com/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -

COPY saltstack.list /etc/apt/sources.list.d/saltstack.list

RUN apt-get update

# Install Salt packages
RUN apt-get -y install salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api

# Install other useful packages
RUN apt-get -y install vim

RUN pip install --upgrade pip
RUN pip install -r /dev_python27.txt

ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV PATH=$PATH:/testing/scripts/:/testing/salt/tests/

VOLUME /testing
