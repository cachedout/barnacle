FROM opensuse/leap:15.0

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt
COPY dev_python34.txt /dev_python34.txt

# Install Salt repo and then install packages
RUN zypper --non-interactive dup
RUN zypper --non-interactive ar https://download.opensuse.org/repositories/systemsmanagement:/saltstack/openSUSE_Leap_15.0/systemsmanagement:saltstack.repo
RUN zypper --non-interactive --gpg-auto-import-keys refresh
RUN zypper --non-interactive in wget git vim python python-xml python-devel python3 python3-devel libopenssl-devel automake autoconf gcc gcc-c++ openssh

# Enable openssh so we can login to the container
RUN ln -s /usr/lib/systemd/system/sshd.service /etc/systemd/system/multi-user.target.wants/
# Set root password to "changeme" and force a change on first login
RUN echo root:changeme | chpasswd
RUN passwd --expire root

# Install pip
RUN wget -O - https://bootstrap.pypa.io/get-pip.py | python3
RUN wget -O - https://bootstrap.pypa.io/get-pip.py | python

RUN pip3 install -r /dev_python34.txt
RUN pip install -r /dev_python27.txt

# Install pudb, get rid of welcome message, and turn on line numbers
RUN pip3 install pudb
RUN pip install pudb
RUN sed -i 's/seen_welcome = .\+/seen_welcome = e999/' /root/.config/pudb/pudb.cfg
RUN sed -i 's/line_numbers = .\+/line_numbers = True/' /root/.config/pudb/pudb.cfg

ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV PATH=/testing/scripts/:/testing/salt/tests/:$PATH
ENV LANG=en_US.UTF-8

RUN mkdir -p /etc/salt /srv/salt

VOLUME /testing
CMD bash
