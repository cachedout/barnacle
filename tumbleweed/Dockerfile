FROM opensuse:tumbleweed

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt

RUN zypper --non-interactive dup
RUN zypper --non-interactive in wget python-pip git
RUN zypper --non-interactive  ar http://download.opensuse.org/repositories/systemsmanagement:/saltstack:/testing/openSUSE_Tumbleweed/systemsmanagement:saltstack:testing.repo

RUN zypper --non-interactive --gpg-auto-import-keys refresh

# Install Salt packages
RUN zypper --non-interactive in salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api

# Install other useful packages
RUN zypper --non-interactive in vim

RUN pip install --upgrade pip
RUN pip install -r /dev_python27.txt

# Install pudb, get rid of welcome message, and turn on line numbers
RUN pip install pudb
RUN sed -i 's/seen_welcome = .\+/seen_welcome = e033/' /root/.config/pudb/pudb.cfg
RUN sed -i 's/line_numbers = .\+/line_numbers = True/' /root/.config/pudb/pudb.cfg

ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV PATH=/testing/scripts/:/testing/salt/tests/:$PATH

VOLUME /testing
