#!/usr/bin/env bash
# run in local

. init_all.profile
. init_ubuntu.profile

UPDATELAUNCH=0
DOWNLOADGAIA=0
GENRERATEFILE=0
STARTGAIA=0
VERSION="v0.35.0"

while getopts "ugfsv:" opt; do
  case ${opt} in
    u)
      UPDATELAUNCH=1
      ;;
    g)
      DOWNLOADGAIA=1
      ;;
    f)
      GENRERATEFILE=1
      ;;
    s)
      STARTGAIA=1
      ;;
    v)
      VERSION="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

function updatelaunch {
    echo "====================== download launch in ${1} ======================"
${SSH}@${1} << eeooff
    if [[ ! -d ${LAUNCH_PATH} ]]; then
       git clone -b cosmos ${LAUNCH_GIT} ${LAUNCH_PATH}
    else
       cd ${LAUNCH_PATH}
       git checkout cosmos
       git pull origin cosmos
    fi

    exit
eeooff
}

function downloadgaia {
     echo "====================== download gaia bins ${VERSION} in ${1} ======================"
${SSH}@${1} << eeooff
    cd ${LAUNCH_PATH}/remote_launch
    ./downloadGaia.sh ${VERSION}

    exit
eeooff
}

function generateGenesisfile {
${SSH}@${1} << eeooff
    cd ${LAUNCH_PATH}/remote_launch/mac_shell
    ./generateLocal.sh

    exit
eeooff
}

function startgaia {
${SSH}@${1} << eeooff
    gaiad version
    nohup gaiad start --home gaianode/gaiad/ --log_level *:info &

    exit
eeooff
}

#2.download bins in every host
#3.
function main {
    echo VERSION:${VERSION}

    if [[ ${UPDATELAUNCH} -eq 1 ]];then
        echo "================================ download launch ================================"
        for host in ${OKCHAIN_TESTNET_ALL_NODE[@]}
        do
             updatelaunch ${host}
        done
    fi

    if [[ ${DOWNLOADGAIA} -eq 1 ]];then
        echo "================================ download gaia bins ================================"
        for host in ${OKCHAIN_TESTNET_ALL_NODE[@]}
        do
             downloadgaia ${host}
        done
    fi

    if [[ ${GENRERATEFILE} -eq 1 ]];then
        generateGenesisfile ${OKCHAIN_TESTNET_ALL_NODE[0]}
    fi

    if [[ ${STARTGAIA} -eq 1 ]];then
        echo "================================ start testnet ================================"
        for host in ${OKCHAIN_TESTNET_ALL_NODE[@]}
        do
            startgaia ${host}
        done
    fi

}

main
