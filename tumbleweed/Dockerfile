FROM opensuse:tumbleweed

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt

RUN zypper --non-interactive dup
RUN zypper --non-interactive in wget python-pip git
RUN zypper --non-interactive  ar http://download.opensuse.org/repositories/systemsmanagement:/saltstack:/testing/openSUSE_Tumbleweed/systemsmanagement:saltstack:testing.repo

RUN zypper --non-interactive --gpg-auto-import-keys refresh

RUN zypper --non-interactive in salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api

RUN pip install --upgrade pip
RUN pip install -r /dev_python27.txt

ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV PATH=$PATH:/testing/scripts/:/testing/salt/tests/

VOLUME /testing
