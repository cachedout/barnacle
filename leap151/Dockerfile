FROM opensuse/leap:15.1

# Make sure /var/tmp exists
RUN test -e /tmp || ln -s /var/tmp /tmp
# Create some dirs that would normally be laid down by
RUN mkdir -p /etc/salt/{master,minion}.d /srv/salt /srv/pillar
# Set a predictable minion ID
RUN echo test >/etc/salt/minion_id

#RUN zypper --non-interactive in wget git vim python python-xml python-devel python3 python3-devel libopenssl-devel automake autoconf gcc gcc-c++ openssh
RUN zypper --non-interactive install wget curl gcc gcc-c++ git openssh python-devel python-xml python3-devel libgit2-devel libffi-devel libxslt-devel libxml2-devel vim iproute2

# Setup environment and UTF-8 locale
ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV PATH=/testing/scripts/:/testing/salt/tests/:$PATH
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.utf8
VOLUME /testing

# Enable openssh so we can login to the container
RUN ln -s /usr/lib/systemd/system/sshd.service /etc/systemd/system/multi-user.target.wants/
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
