FROM debian:wheezy

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt

RUN apt-get update
RUN apt-get -y install wget python-dev apt-transport-https vim
RUN apt-get update
RUN wget -O - https://repo.saltstack.com/apt/debian/7/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -

COPY saltstack.list /etc/apt/sources.list.d/saltstack.list

RUN apt-get update

# Install Salt packages
RUN apt-get -y install salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api

# Install pip
RUN wget -O - https://bootstrap.pypa.io/get-pip.py | python

# six and urllib3 are already installed as deps, but are too old for some of
# the packages that depend on them which will be installed via the requirements
# file below. Additionally, they cannot be removed using newer pip since they
# were built using distutils. Uninstalling the packages will remove stuff we
# don't want to be removed, so while ugly, the best solution is to remove the
# files so that newer versions of them can be installed.
RUN rm /usr/lib/python2.7/dist-packages/six-1.1.0.egg-info /usr/lib/python2.7/dist-packages/six.py
RUN rm -rf /usr/lib/python2.7/dist-packages/urllib3-1.7.1.egg-info /usr/lib/python2.7/dist-packages/urllib3

# Install additional requisites for test suite
RUN pip install -r /dev_python27.txt

# Install pudb, get rid of welcome message, and turn on line numbers
RUN pip install pudb
RUN sed -i 's/seen_welcome = .\+/seen_welcome = e999/' /root/.config/pudb/pudb.cfg
RUN sed -i 's/line_numbers = .\+/line_numbers = True/' /root/.config/pudb/pudb.cfg

ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV PATH=/testing/scripts/:/testing/salt/tests/:$PATH
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN mkdir -p /etc/salt /srv/salt

VOLUME /testing
