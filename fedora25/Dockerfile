FROM fedora:25

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt

RUN dnf -y install wget gcc git redhat-rpm-config salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api python-pip python-devel

RUN pip install -r /dev_python27.txt

# Install pudb, get rid of welcome message, and turn on line numbers
RUN pip install pudb
RUN sed -i 's/seen_welcome = .\+/seen_welcome = e033/' /root/.config/pudb/pudb.cfg
RUN sed -i 's/line_numbers = .\+/line_numbers = True/' /root/.config/pudb/pudb.cfg

ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV PATH=/testing/scripts/:/testing/salt/tests/:$PATH

VOLUME /testing
