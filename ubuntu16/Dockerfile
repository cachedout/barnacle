FROM ubuntu:16.04

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt
COPY dev_python34.txt /dev_python34.txt

RUN apt-get update
RUN apt-get -y install vim wget python-pip python3-dev python3-pip libssl-dev
RUN wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -

COPY saltstack.list /etc/apt/sources.list.d/saltstack.list

RUN apt-get update

# Install Salt packages
RUN apt-get -y install salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api

RUN apt-get -y install openssh-server
# Turn on password auth for root user
RUN sed -i 's/.*PermitRootLogin.\+/PermitRootLogin yes/' /etc/ssh/sshd_config
# Set root password to "changeme" and force a change on first login
RUN echo root:changeme | chpasswd
RUN passwd --expire root

# Make sure that unit files that don't use /lib work
RUN ln -s /lib/systemd/systemd /usr/lib/systemd/systemd

# Disable salt services at boot
RUN systemctl disable salt-master.service
RUN systemctl disable salt-minion.service
RUN systemctl disable salt-syndic.service
RUN systemctl disable salt-api.service

RUN pip2 install --upgrade pip
RUN pip3 install --upgrade pip

# Installing and upgrading python3 pip makes /usr/local/bin/pip == pip3, by
# installing an exact copy of the pip3 binary at /usr/local/bin/pip. Overwrite
# this so that pip still means python2's pip like we're used to using.
RUN cp -f /usr/local/bin/pip2 /usr/local/bin/pip

# Manually remove psutil
RUN rm -rf /usr/lib/python2.7/dist-packages/psutil* /usr/share/doc/python-psutil

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
