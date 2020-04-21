FROM ubuntu:16.04

# Make sure /var/tmp exists
RUN test -e /tmp || ln -s /var/tmp /tmp
# Create some dirs that would normally be laid down by
RUN mkdir -p /etc/salt/{master,minion}.d /srv/salt /srv/pillar
# Set a predictable minion ID
RUN echo test >/etc/salt/minion_id
# Make sure that unit files that don't use /lib work
RUN ln -s /lib/systemd/systemd /usr/lib/systemd/systemd

RUN apt-get update
RUN apt-get -y install wget curl gcc g++ git openssh-server python-dev python3-dev vim iproute less locales

# Make sure UTF8 locale is available
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

# Setup environment and UTF-8 locale
ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV PATH=/testing/scripts/:/testing/salt/tests/:$PATH
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.utf8
VOLUME /testing

# Turn on password auth for root user
RUN sed -i 's/.*PermitRootLogin.\+/PermitRootLogin yes/' /etc/ssh/sshd_config
# Set root password to "changeme" and force a change on first login
RUN echo root:changeme | chpasswd
RUN passwd --expire root

# Get pip installed
RUN curl https://bootstrap.pypa.io/get-pip.py >/get-pip.py
RUN python2 /get-pip.py
RUN python3 /get-pip.py

# Install Python packages
COPY requirements.txt /requirements.txt
RUN python2 -m pip install -r /requirements.txt
RUN python3 -m pip install -r /requirements.txt

# Get rid of pudb welcome message, and turn on line numbers
RUN sed -i 's/seen_welcome = .\+/seen_welcome = e999/' /root/.config/pudb/pudb.cfg
RUN sed -i 's/line_numbers = .\+/line_numbers = True/' /root/.config/pudb/pudb.cfg
