FROM debian:jessie

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt

RUN apt-get update
RUN apt-get -y install wget python-dev vim gcc g++ --fix-missing
RUN wget -O - https://repo.saltstack.com/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -

COPY saltstack.list /etc/apt/sources.list.d/saltstack.list

RUN apt-get update

# Install Salt packages
RUN apt-get -y install salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api

# Install pip
RUN wget -O - https://bootstrap.pypa.io/get-pip.py | python

# psutil is already installed as a dep, but is too old for some of the packages
# that depend on it which will be installed via the requirements file below.
# Additionally, it cannot be removed using newer pip since it were built using
# distutils. Uninstalling the package will remove stuff we don't want to be
# removed, so while ugly, the best solution is to remove the files so that
# newer versions of psutil can be installed.
RUN rm -rf /usr/lib/python2.7/dist-packages/_psutil_posix.x86_64-linux-gnu.so /usr/lib/python2.7/dist-packages/_psutil_linux.x86_64-linux-gnu.so /usr/lib/python2.7/dist-packages/psutil-2.1.1.egg-info /usr/lib/python2.7/dist-packages/psutil

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
