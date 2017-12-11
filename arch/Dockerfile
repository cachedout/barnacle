FROM base/archlinux

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt

RUN pacman -Syy
RUN pacman -S --noconfirm python2-pip gcc git openssl
RUN pip2 install -r /dev_python27.txt

# Install pudb, get rid of welcome message, and turn on line numbers
RUN pip2 install pudb
RUN sed -i 's/seen_welcome = .\+/seen_welcome = e033/' /root/.config/pudb/pudb.cfg
RUN sed -i 's/line_numbers = .\+/line_numbers = True/' /root/.config/pudb/pudb.cfg

# Add symlink for python2
RUN ln -s /usr/bin/python2 /usr/bin/python

ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV PATH=/testing/scripts/:/testing/salt/tests/:$PATH

VOLUME /testing
