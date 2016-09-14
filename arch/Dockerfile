FROM base/archlinux

COPY base.txt /base.txt
COPY dev_python27.txt /dev_python27.txt

RUN pacman -Syy
RUN pacman -S --noconfirm python2-pip gcc git openssl
RUN pip2 install -r /dev_python27.txt

VOLUME /testing
