FROM centos:5

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt

RUN yum -y install wget gcc zlib-devel openssl-devel cpio expat-devel gettext-devel make vim
RUN wget https://repo.saltstack.com/yum/redhat/salt-repo-latest-1.el5.noarch.rpm
RUN rpm -ivh salt-repo-latest-1.el5.noarch.rpm
RUN rm -f salt-repo-latest-1.el5.noarch.rpm
RUN yum clean expire-cache

RUN yum -y install salt-master
RUN yum -y install salt-minion
RUN yum -y install salt-ssh
RUN yum -y install salt-syndic
RUN yum -y install salt-cloud
RUN yum -y install salt-api

RUN wget --no-check-certificate https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/git-core/git-1.9.0.tar.gz
RUN tar xvzf git-1.9.0.tar.gz
WORKDIR git-1.9.0
RUN ./configure
RUN make
RUN make install

RUN mv /usr/bin/python /usr/bin/python2.4
RUN ln -s /usr/bin/python2.6 /usr/bin/python

RUN easy_install-2.6 pip
#Unbreak yum
#RUN pip install yum

RUN pip install -r /dev_python27.txt

# Install pudb, get rid of welcome message, and turn on line numbers
RUN pip install pudb
RUN sed -i 's/seen_welcome = .\+/seen_welcome = e033/' /root/.config/pudb/pudb.cfg
RUN sed -i 's/line_numbers = .\+/line_numbers = True/' /root/.config/pudb/pudb.cfg

ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV PATH=/testing/scripts/:/testing/salt/tests/:$PATH

VOLUME /testing
