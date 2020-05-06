FROM debian:buster

# Make sure 32-bit package installs are enabled
RUN dpkg --add-architecture i386
# Make sure /var/tmp exists
RUN test -e /tmp || ln -s /var/tmp /tmp
# Create some dirs for Salt
RUN mkdir -p /etc/salt/master.d /etc/salt/minion.d /srv/salt /srv/pillar
# Point the minion at localhost
RUN echo "master: localhost" > /etc/salt/minion
# Create a pillar top file and empty pillar SLS file
RUN echo "base:\n  test:\n    - test" >/srv/pillar/top.sls
RUN touch /srv/pillar/test.sls
# Set a predictable minion ID
RUN echo test >/etc/salt/minion_id

# Create command stubs to ensure Python 3 is the default
RUN for cmd in salt salt-api salt-call salt-cloud salt-cp salt-extend \
               salt-key salt-master salt-minion salt-proxy salt-run salt-ssh \
               salt-syndic salt-unity spm; do \
        echo "#!/bin/bash\n\npython3 /testing/scripts/$cmd \"\$@\"" >/usr/bin/$cmd; \
        chmod 0755 /usr/bin/$cmd; \
    done

# Now do Python 2
RUN for cmd in salt salt-api salt-call salt-cloud salt-cp salt-extend \
               salt-key salt-master salt-minion salt-proxy salt-run salt-ssh \
               salt-syndic salt-unity spm; do \
        echo "#!/bin/bash\n\npython2 /testing/scripts/$cmd \"\$@\"" >/usr/bin/${cmd}2; \
        chmod 0755 /usr/bin/${cmd}2; \
    done

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget curl gcc g++ git openssh-server python-dev python3-dev libgit2-dev libffi-dev libxslt-dev libxml2-dev libssl-dev vim iproute2 less locales

# Make sure UTF8 locale is available
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

# Setup environment and UTF-8 locale
ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.utf8
VOLUME /testing

# Enable sshd
RUN ln -sf /lib/systemd/system/ssh.service /etc/systemd/system/multi-user.target.wants/
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
