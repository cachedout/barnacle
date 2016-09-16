if [[ -e /usr/bin/sw_vers && `/usr/bin/sw_vers -productName` == "Mac OS X" ]]; then
    SUDO=""
    DOCKER="/usr/local/bin/docker"
else
    SUDO="sudo"
    DOCKER="/usr/bin/docker"
fi

csalt_func() {
    image=$1
    shift
    $SUDO $DOCKER run --name salt-$image --rm -itv ~/devel/salt/:/testing salt-$image ${@:-/bin/bash}
}

cexec_func() {
    image=$1
    shift
    $SUDO $DOCKER exec -ti salt-$image ${@:-/bin/bash}
}

ctest_func() {
    $SUDO $DOCKER /usr/bin/docker run --rm -itv ~/devel/salt:/testing salt-$1 python2 /testing/tests/runtests.py -n $2
}

alias cshell='csalt_func'
alias cexec='cexec_func'
alias cts='ctest_func'

