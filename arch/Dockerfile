FROM base/archlinux

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt
COPY dev_python34.txt /dev_python34.txt

RUN pacman -Syyu --noconfirm python2 python gcc wget curl git openssl man man-pages

# Install pip
RUN wget -O - https://bootstrap.pypa.io/get-pip.py | python2
RUN wget -O - https://bootstrap.pypa.io/get-pip.py | python

RUN pip2 install -r /dev_python27.txt
RUN pip install -r /dev_python34.txt

# Install pudb, get rid of welcome message, and turn on line numbers
RUN pip2 install pudb
RUN pip install pudb
RUN sed -i 's/seen_welcome = .\+/seen_welcome = e999/' /root/.config/pudb/pudb.cfg
RUN sed -i 's/line_numbers = .\+/line_numbers = True/' /root/.config/pudb/pudb.cfg

ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV PATH=/testing/scripts/:/testing/salt/tests/:$PATH
ENV LANG=en_US.UTF-8

RUN mkdir -p /etc/salt /srv/salt

VOLUME /testing
