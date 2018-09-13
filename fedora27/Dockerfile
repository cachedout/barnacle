FROM fedora:27

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt
COPY dev_python34.txt /dev_python34.txt

RUN dnf -y install redhat-rpm-config salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api python-devel python3-devel vim wget gcc git findutils iproute procps-ng passwd

# Install openssh so we can ssh into the container
RUN dnf -y install openssh-server
# Set root password to "changeme" and force a change on first login
RUN echo root:changeme | chpasswd
RUN passwd --expire root

RUN wget -O - https://bootstrap.pypa.io/get-pip.py | python
RUN wget -O - https://bootstrap.pypa.io/get-pip.py | python3
RUN pip install -r /dev_python27.txt
RUN pip3 install -r /dev_python34.txt

# Install pudb, get rid of welcome message, and turn on line numbers
RUN pip install pudb
RUN pip3 install pudb
RUN sed -i 's/seen_welcome = .\+/seen_welcome = e999/' /root/.config/pudb/pudb.cfg
RUN sed -i 's/line_numbers = .\+/line_numbers = True/' /root/.config/pudb/pudb.cfg

ENV PYTHONPATH=/testing
ENV PATH=/testing/scripts:/testing/salt/tests:$PATH
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN mkdir -p /etc/salt /srv/salt

VOLUME /testing
CMD bash
