FROM centos:7

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt
COPY dev_python34.txt /dev_python34.txt

RUN yum -y install wget gcc git
RUN yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm
RUN yum clean expire-cache

RUN yum -y install salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api

# Install openssh so we can ssh into the container
RUN yum -y install openssh-server
# Set root password to "changeme" and force a change on first login
RUN echo root:changeme | chpasswd
RUN passwd --expire root

RUN yum -y install epel-release

RUN yum -y install python-pip python-devel python34-pip python34-devel vim iproute

RUN pip install -r /dev_python27.txt
RUN pip3 install -r /dev_python34.txt

# Install pudb, get rid of welcome message, and turn on line numbers
RUN pip install pudb
RUN pip3 install pudb
RUN sed -i 's/seen_welcome = .\+/seen_welcome = e033/' /root/.config/pudb/pudb.cfg
RUN sed -i 's/line_numbers = .\+/line_numbers = True/' /root/.config/pudb/pudb.cfg

ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV PATH=/testing/scripts/:/testing/salt/tests/:$PATH
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

VOLUME /testing
