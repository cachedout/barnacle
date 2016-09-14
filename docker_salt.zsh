if [[ -e /usr/bin/sw_vers && `/usr/bin/sw_vers -productName` == "Mac OS X" ]]; then
    SUDO=""
    DOCKER="/usr/local/bin/docker"
else
    SUDO="sudo"
    DOCKER="/usr/bin/docker"
fi

csalt_func() {
    $SUDO $DOCKER run --name salt-$1 --rm -itv ~/devel/salt/:/testing salt-$1 /bin/bash
}

cexec_func() {
    $SUDO $DOCKER exec -ti salt-$1 /bin/bash
}

ctest_func() {
    $SUDO $DOCKER /usr/bin/docker run --rm -itv ~/devel/salt:/testing salt-$1 python2 /testing/tests/runtests.py -n $2
}

alias cshell='csalt_func'
alias cexec='cexec_func'
alias cts='ctest_func'

