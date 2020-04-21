FROM ubuntu:14.04

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt
COPY dev_python34.txt /dev_python34.txt

RUN apt-get update
RUN apt-get -y install wget python-pip python-dev openssl libssl-dev
RUN wget -O - https://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -

COPY saltstack.list /etc/apt/sources.list.d/saltstack.list

RUN apt-get update

# Install Salt packages
RUN apt-get -y install salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api

# Install other helpful packages
RUN apt-get -y install vim python3-dev python3-pip libssl-dev

# Manually remove psutil, six
RUN rm -rf /usr/lib/python2.7/dist-packages/psutil*
RUN rm -rf /usr/lib/python2.7/dist-packages/six* /usr/lib/python3/dist-packages/six* /usr/lib/python3/dist-packages/__pycache__/six*.*
RUN rm -rf /usr/lib/python2.7/dist-packages/urllib3-1.7.1.egg-info /usr/lib/python2.7/dist-packages/urllib3 /usr/lib/python3/dist-packages/urllib3-1.7.1.egg-info /usr/lib/python3/dist-packages/urllib3

RUN pip install --upgrade pip
RUN pip3 install --upgrade pip
RUN pip install -r /dev_python27.txt
RUN pip3 install -r /dev_python34.txt

# Install pudb, get rid of welcome message, and turn on line numbers
RUN pip install pudb
RUN pip3 install pudb
RUN sed -i 's/seen_welcome = .\+/seen_welcome = e999/' /root/.config/pudb/pudb.cfg
RUN sed -i 's/line_numbers = .\+/line_numbers = True/' /root/.config/pudb/pudb.cfg

ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV PATH=/testing/scripts/:/testing/salt/tests/:$PATH
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN mkdir -p /etc/salt /srv/salt

VOLUME /testing
