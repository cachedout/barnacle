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

1. `/{run,tmp}` mounted as tmpfs
2. The container needs read-only access to your cgroups
3. You need to specify the path to the systemd binary as the command or entrypoint for the
   container.

For example:

```bash
docker run --detach --name container_name --tmpfs /tmp --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v ~/devel/salt:/testing cent7 /usr/lib/systemd/systemd
```

This will launch the container running systemd and detach from it.

To get a shell, evoke it with a tty in interactive mode.

```bash
docker exec -it container_name /bin/bash
```

Fortunately, both starting a container under systemd and evoking an interactive shell are supported via the .zsh aliases described in the section below.


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

`cdshel` <-- evoke an interactive shell in a detached container (defaults to bash)

`csalt-call ubuntu14 state.sls test` <-- Run any salt-call command. csalt <os> <cmd> <args>

# Using Barnacle Python Module #

## Installing and Setup Barnacle Python Module ##

```
git clone https://github.com/cachedout/barnacle.git
cd barnacle
pip install -e .
```

Add configurations to file: `/etc/barnacle.conf`

```
salt_dir: /home/ch3ll/git/salt/
barnacle_dir: /home/ch3ll/git/barnacle/
```

**salt_dir** is the location to your locally cloned git repo of salt. The barnacle python module will use this directory to run salt from within the container

**barnacle_dir** is the location where you cloned the barnacle directory. The barnacle python module will use this directory when building docker images. It searches this directory for any dockerfiles and builds from those files.


## Barnacle Commands ##
###### barnacle-build ######
Builds dockerimages from dockerfiles. Will create images with the name `salt` + the os.

`barnacle-build -o <os>` <-- builds a specific os
`barnacle-build -a` <-- builds all OSs in the specified barnacle directory

###### barnacle-shell ######
Starts and shells into a container

`barnacle-shell -o <os>` <-- starts and shells into specific os container

###### barnacle-test ######
Starts a container and runs a test using salt's test runner.

`barnacle-test -o <os> -t <salt-test>` <-- starts a specific os container and runs specified salt test.

NOTE: when using `<os>` in any of these barnacle commands, you need to use the name of the directory where the Dockerfile exists. For example if you want to build centos7 you would use `cent7` because that is the name of the directory in barnacle for that os.
