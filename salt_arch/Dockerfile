FROM centos:7

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt
COPY salt_setup /tmp/salt_setup/

RUN yum -y install wget gcc git
RUN yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest-1.el7.noarch.rpm
RUN yum clean expire-cache

RUN yum -y install salt-master
RUN yum -y install salt-minion
RUN yum -y install salt-ssh
RUN yum -y install salt-syndic
RUN yum -y install salt-cloud
RUN yum -y install salt-api

RUN yum -y install epel-release

RUN yum -y install python-pip
RUN yum -y install python-devel

RUN yum -y install vim

RUN pip install -r /dev_python27.txt

ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV PATH=$PATH:/testing/scripts/:/testing/salt/tests/
RUN salt-call --local --file-root=/tmp/salt_setup/ state.sls SALT_ARCH.TYPE_OF_ARCH

VOLUME /testing
