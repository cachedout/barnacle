FROM centos:5

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt

RUN yum -y install wget gcc git
RUN wget https://repo.saltstack.com/yum/redhat/salt-repo-latest-1.el5.noarch.rpm
RUN rpm -ivh salt-repo-latest-1.el5.noarch.rpm
RUN rm -f salt-repo-latest-1.el5.noarch.rpm
RUN yum clean expire-cache

RUN yum -y install salt-master
RUN  yum -y install salt-minion
RUN yum -y install salt-ssh
RUN yum -y install salt-syndic
RUN yum -y install salt-cloud
RUN yum -y install salt-api

#RUN pip2 install -r /dev_python27.txt

VOLUME /testing
