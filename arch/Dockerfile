FROM base/archlinux

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt

RUN pacman -Syy
RUN pacman -S --noconfirm python2-pip gcc git openssl
RUN pip2 install -r /dev_python27.txt

ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV PATH=$PATH:/testing/scripts/:/testing/salt/tests/

VOLUME /testing
