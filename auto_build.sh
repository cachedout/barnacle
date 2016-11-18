#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ALL_DIRS=$(find ${CURRENT_DIR} -name Dockerfile -printf '%h\n' | for i in `xargs`; do basename $i; done)

function usage()
{
        echo "=========USAGE========="
        echo "$0 -o <os> -a <all os> -s <salt setup>"
        echo "You can only use -o, -s or -a not both"
        echo "When specifying -o you need to simply specify the OS/dir name you want to build"
        echo "Your options for os are the following:"
        echo "${ALL_DIRS}"
        echo "When specifying -a this will build all OSs in this repo"
        echo '      ./build.sh  -a'
        echo "When specifying -o <os> this will build just that OS in this repo"
        echo '      ./build.sh  -o "centos5'
        echo "When specifying -s <salt setup> -t <setup type> it will build a specific salt setup"
        echo "For example running -s api -t cherrypy will build a docker image with cherrypy api setup"
        echo "The current salt setups available are as follows:"
        exit
}

while getopts "o:s:t:ah" opt; do
  case $opt in
    o)
      OS=${OPTARG}
      ;;
    s)
      SETUP=True
      ARCH=${OPTARG}
      ;;
    t)
      ARCH_TYPE=${OPTARG}
      ;;
    a)
      ALL=True
      ;;
    h)
      usage
      ;;
    *)
      usage
      ;;
  esac
done

# function that finds all Dockerfile dirs and builds them
function build_all(){
    for i in ${ALL_DIRS};do
        cd ${CURRENT_DIR}/$i;
        echo "BUILDING salt-${i}"
        docker build -t salt-${i} . &
    done
}

# function that builds specified OS
function build_os() {
    specific_os=$1
    cd ${CURRENT_DIR}/${specific_os}
    echo "BUILDING ${specific_os}"
    docker build -t salt-${specific_os} .
}

function build_setup() {
    f_arch=$1
    f_arch_type=$2
    dockerfile_template="${CURRENT_DIR}/salt_arch/"
    tmp_dir="/tmp/${f_arch}/${f_arch_type}/"

    echo "Creating temp build directory"
    mkdir -p ${tmp_dir}
    cp -r ${dockerfile_template}/* ${tmp_dir}
    cd ${tmp_dir}
    sed -i -e "s/SALT_ARCH/${f_arch}/g" -e "s/TYPE_OF_ARCH/${f_arch_type}/g" Dockerfile


    echo "BUILDING ${f_arch}-${f_arch_type}"
    docker build -t salt-${f_arch}-${f_arch_type} .
}


if [ -z ${OS} ] && [ -z ${ALL} ] && [ -z ${ARCH} ]; then
    usage
fi
[[ ! -z ${OS} ]] && build_os ${OS}
[[ ! -z ${SETUP} ]] && build_setup ${ARCH} ${ARCH_TYPE}
[[ ! -z ${ALL} ]] && build_all
