FROM fedora:26

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt
COPY dev_python34.txt /dev_python34.txt

# Have to remove this first because installing the full version of vim will
# result in conflicting manpage files
RUN dnf -y erase vim-minimal

RUN dnf -y install wget gcc git redhat-rpm-config salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api python-pip python-devel python3-pip python3-devel vim iproute procps-ng

# Install openssh so we can ssh into the container
RUN dnf -y install openssh-server
# Set root password to "changeme" and force a change on first login
RUN echo root:changeme | chpasswd
RUN passwd --expire root

RUN pip install -r /dev_python27.txt
# Install fails on older setuptools for Python 3
RUN pip3 install --upgrade setuptools
RUN pip3 install -r /dev_python34.txt

# Install pudb, get rid of welcome message, and turn on line numbers
RUN pip install pudb
RUN pip3 install pudb
RUN sed -i 's/seen_welcome = .\+/seen_welcome = e033/' /root/.config/pudb/pudb.cfg
RUN sed -i 's/line_numbers = .\+/line_numbers = True/' /root/.config/pudb/pudb.cfg

ENV PYTHONPATH=/testing
ENV PATH=/testing/scripts:/testing/salt/tests:$PATH
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

VOLUME /testing
CMD bash
