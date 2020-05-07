FROM opensuse/tumbleweed:latest

# Make sure /var/tmp exists
RUN test -e /tmp || ln -s /var/tmp /tmp
# Create some dirs for Salt
RUN mkdir -p /etc/salt/{master,minion}.d /srv/salt /srv/pillar
# Point the minion at localhost
RUN echo "master: localhost" > /etc/salt/minion
# Create a pillar top file and empty pillar SLS file
RUN echo -e "base:\n  test:\n    - test" >/srv/pillar/top.sls
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

RUN zypper --non-interactive dup
RUN zypper --non-interactive install wget curl gcc gcc-c++ git openssh python-devel python-xml python3-devel libgit2-devel libffi-devel libxslt-devel libxml2-devel vim iproute2

# Setup environment and UTF-8 locale
ENV PYTHONPATH=/testing/:/testing/salt-testing/
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.utf8
VOLUME /testing

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
