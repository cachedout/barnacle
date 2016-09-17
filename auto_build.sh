#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ALL_DIRS=$(find ${CURRENT_DIR} -name Dockerfile -printf '%h\n' | for i in `xargs`; do basename $i; done)

function usage()
{
        echo "=========USAGE========="
        echo "$0 -o <os> -a <all os>"
        echo "You can only use -o or -a not both"
        echo "When specifying -o you need to simply specify the OS/dir name you want to build"
        echo "Your options for os are the following:"
        echo "${ALL_DIRS}"
        echo "When specifying -a this will build all OSs in this repo"
        echo '      ./build.sh  -a'
        echo "When specifying -o <os> this will build just that OS in this repo"
        echo '      ./build.sh  -o "centos5'
        exit
}

while getopts "o:ah" opt; do
  case $opt in
    o)
      OS=${OPTARG}
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


if [ -z ${OS} ] && [ -z ${ALL} ]; then
    usage
fi
[[ ! -z ${OS} ]] && build_os ${OS}
[[ ! -z ${ALL} ]] && build_all
