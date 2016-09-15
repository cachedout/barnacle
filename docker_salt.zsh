if [[ -e /usr/bin/sw_vers && `/usr/bin/sw_vers -productName` == "Mac OS X" ]]; then
    SUDO=""
    DOCKER="/usr/local/bin/docker"
else
    SUDO="sudo"
    DOCKER="/usr/bin/docker"
fi

csalt_func() {
    $SUDO $DOCKER run --rm -itv ~/devel/salt/:/testing salt-$1 /bin/bash
}

ctest_func() {
    #function variables
    local no_clean=''
    local rm='--rm'
    local usage='False'
    local os=${1}
    local test=${2}

    # get all opts
    while test $# -gt 0;do
      case "$1" in
        '--no-clean')
          local rm=''
          local no_clean='--no-clean'
          ;;
        '--help'|'-h')
          local usage='True'
          ;;
      esac
      shift
    done

    # cannot call a usage funciton because it wont exit and will run docker command
    # so need to put in if function
    if [ ${usage} = 'True' ]; then
        echo "usage: cts <os> <testmodule> <options>"
        echo "example: cts ubuntu14 integration.modules.test"
        echo "options available:"
        echo "--no-clean -> will add --no-clean to runner and ensure -rm is not added to docker run cmd"
        echo "--help|-h -> will print out usage information"
    else
        $SUDO $DOCKER run ${rm} -itv $LOCAL_VOLUME:/testing salt-${os} python2 /testing/tests/runtests.py "${no_clean}" -n ${test}
    fi
}

alias cshell='csalt_func'
alias cts='ctest_func'

