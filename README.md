# barnacle
Docker files for SaltStack

Note: It is strongly recommended that the default storage engine for Docker not be set to use the loopback/devicemapper.
This will result in very slow builds and poor performance. Choose `overlay` or `overlay2` if possible.

TL;DR
=====

For the impatient, images are available on [Docker Hub](https://hub.docker.com/r/cachedout/barnacle/).

To use them, replace the name of the containers in the examples below with the path to the image tag. For example, replace instances of `salt-arch` with `cachedout/arch`.


Installation
============
The following steps will walk you through building and running a Docker image for Arch Linux.

To build and test another OS, simply change the OS identifier where appropriate.

NOTE: This guide assumes that one's local salt development directory is in `~/devel/salt`. If this
is not the case, adjust the paths below accordingly.

To build an image, change to an image directory and type: `sudo docker build -t salt-arch`.

This will download a base image and apply the necessary layers to ensure it has all the layer necessary
to develop Salt with, including all of the development deps.

After the container is built, you can shell into it and have a look around:

`udo /usr/bin/docker run --rm -itv ~/devel/salt/:/testing salt-arch /bin/bash`

Your local Salt development directory will be mounted into /testing. Any change you make locally
will be immediatley reflected there and vice-versa.

You can of course run the tests if you like: `python2 /testing/tests/runtests.py`

Running the tests and then exiting
==================================

There is no need to create a shell just to run a test. You can do this with one command:

`sudo /usr/bin/docker run --rm -itv ~/devel/salt:/testing salt-arch python2 /testing/tests/runtests.py`

Again, this will operate on your local checkout of the Salt repo so you can quickly make changes and then
immediatley see how they will work on any given platform.

Using .zsh aliases
==================

This repo includes a `docker_salt.zsh` file. It makes running things even easier. Importing it into your
shell is an exercise for the reader. ;]

To run a single test:

`cts arch integration.modules.beacons` <-- Runs the becaons tests in an Arch container

`cshell arch` <-- Gives you a shell in an Arch container
