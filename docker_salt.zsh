LOCAL_VOLUME="${HOME}/devel/salt/"
BARNACLE_DIR="${HOME}/devel/barnacle"
LOCAL_FILEROOTS="/srv/salt"

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
    $SUDO $DOCKER run --name salt-$image --rm -itv ${LOCAL_VOLUME}:/testing salt-$image ${@:-/bin/bash}
}

cexec_func() {
    image=$1
    shift
    $SUDO $DOCKER exec -ti salt-$image ${@:-/bin/bash}
}

ctest_func() {
    #function variables
    local no_clean=''
    local rm='--rm'
    local usage='False'
    local image=${1}
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
        $SUDO $DOCKER run ${rm} -itv ${LOCAL_VOLUME}:/testing salt-${image} python2 /testing/tests/runtests.py "${no_clean}" -n ${test}
    fi
}

cbuild_func() {
    sudo ${BARNACLE_DIR}/auto_build.sh $1 $2
}

csalt-call_cmd_func() {
    local image=$1
    local salt_cmd=$2
    local salt_args=$3
    $SUDO $DOCKER run --name salt-$image --rm -itv ${LOCAL_VOLUME}:/testing -v ${LOCAL_FILEROOTS}:/srv/salt/ salt-$image salt-call --local ${salt_cmd} ${salt_args}
}

cstart-systemd_func() {
    local container=$1
    local image=$2
    if test -z "$container"; then
        echo "Missing container name!" 1>&2
        exit 1
    fi
    if test -z "$image"; then
        echo "Missing image name!" 1>&2
        exit 2
    fi

    $SUDO $DOCKER run -d --name $container --cap-add SYS_ADMIN -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v ${LOCAL_VOLUME}:/testing $image /usr/lib/systemd/systemd
}

cssh_func() {
    local container=$1
    if test -z "$container"; then
        echo "Missing container name!" 1>&2
        exit 1
    fi

    local ipaddr=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $container)

    # Disable strict checking because docker will reuse IP addresses
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "root@$ipaddr"
}

# ALIASES
alias cshell='csalt_func'
alias cexec='cexec_func'
alias cts='ctest_func'
alias cbuild='cbuild_func'
alias csalt-call='csalt-call_cmd_func'
alias cstart-systemd='cstart-systemd_func'
alias cssh='cssh_func'
