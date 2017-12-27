# barnacle
Docker files for SaltStack

Note: It is strongly recommended that the default storage engine for Docker not
be set to use the loopback/devicemapper. This will result in very slow builds
and poor performance. Choose `overlay` or `overlay2` if possible.

TL;DR (Lazy version)
====================

For the impatient, images are available
on [Docker Hub](https://hub.docker.com/r/cachedout/barnacle/).

To pull images: `docker pull cachedout/barnacle`

To use them, replace the name of the containers in the examples below with the
path to the image tag. For example, replace instances of `salt-arch` with
`cachedout/barnacle:arch`.


Installation
============

The following steps will walk you through building and running a Docker image
for Arch Linux.

To build and test another OS, simply change the OS identifier where appropriate.

If you are running Docker for Mac, the `sudo`s below are not necessary.

NOTE: This guide assumes that one's local salt development directory is in
`~/devel/salt`. If this is not the case, adjust the paths below accordingly.

To build an image, change to an image directory and type: `sudo docker build -t
salt-arch .`.

This will download a base image and apply the necessary layers to ensure it has
all the layer necessary to develop Salt with, including all of the development
deps.

After the container is built, you can shell into it and have a look around:

`sudo /usr/bin/docker run --rm -itv ~/devel/salt/:/testing salt-arch /bin/bash`

Your local Salt development directory will be mounted into /testing. Any change
you make locally will be immediatley reflected there and vice-versa.

You can of course run the tests if you like: `python2
/testing/tests/runtests.py`

Running the tests and then exiting
==================================

There is no need to create a shell just to run a test. You can do this with one
command:

`sudo /usr/bin/docker run --rm -itv ~/devel/salt:/testing salt-arch python2 /testing/tests/runtests.py`

Again, this will operate on your local checkout of the Salt repo so you can
quickly make changes and then immediatley see how they will work on any given
platform.

Run a container using systemd
=============================

**NOTE: currently only supported for the following images: `cent7`, `fedora26`,
`fedora27`, `ubuntu16`, `debian9`**

To start a container using systemd you need three things:

1. `CAP_SYS_ADMIN`
2. The container needs read-only access to your cgroups
3. You need to specify the path to the systemd binary as the command for the
   container.

For example:

```bash
docker run --detach --name container_name --cap-add SYS_ADMIN -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v ~/devel/salt:/testing cent7 /usr/lib/systemd/systemd
```

This will launch the container running systemd and detach from it.

To get a shell, you'll need to ssh into the container. Because Docker re-uses
IP addresses, you'll want to disable strict host key checking and tell ssh not
to write to your `known_hosts` file. You'll also need to get the IP address.
This can all be done via a truly horrific-looking shell one-liner:

```bash
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "root@$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' container_name)"
```

Once you've connected, use the initial password `changeme` and you'll
immediately be prompted to set a new password. If you would like to avoid this
when building your own copy of the container, edit the Dockerfile before
building. You can simply comment out the `passwd` line and subtitute your own
preferred password in the `chpasswd` line.

Fortunately, both starting a container under systemd and SSH-ing into it are
supported via the .zsh aliases described in the section below.

Using .zsh aliases
==================

This repo includes a `docker_salt.zsh` file. It makes running things even
easier. Importing it into your shell is an exercise for the reader. ;] It
understands if you are running Docker for Mac and does not `sudo` for the docker
commands.

To run a single test:

`cts arch integration.modules.beacons` <-- Runs the beacons tests in an Arch container

`cshell arch` <-- Gives you a shell in an Arch container

`cexec arch` <-- Gives you a shell in an already running Arch container (use after cshell)

`cbuild -a` <-- Builds all OSs in the repo

`cbuild -o <OS>` <-- Builds a specific OS in the repo

`csalt ubuntu14 state.sls test` <-- Run a salt command

`csalt-call ubuntu14 state.sls test` <-- Run a salt-call command

`cstart-systemd container_name cent7` <-- Start `container_name` under systemd using image `salt-cent7`

`cssh container_name` <-- SSH into `container_name`
