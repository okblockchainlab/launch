#!/usr/bin/env bash
# run in local

. init_all.profile
. init_ubuntu.profile

while getopts "d:v:" opt; do
  case ${opt} in
    d)
      DOWNLOAD="$OPTARG"
      ;;
    v)
      VERSION="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

function downloadlaunch {
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

function moveGenesisfile {
     echo "====================== move launch/genesis.json ======================"
${SSH}@${1} << eeooff
    mkdir ${GENESIS_PATH}
    cp -f ${LAUNCH_PATH}/genesis.json ${GENESIS_PATH}

    exit
eeooff
}

#2.download bins in every host
#3.
function main {
    echo DOWNLOAD_LAUNCH:${DOWNLOAD}
    echo VERSION:${VERSION}

    echo "================================ download launch ================================"
    for host in ${OKCHAIN_TESTNET_ALL_NODE[@]}
    do
         downloadlaunch ${host}
    done

    echo "================================ download gaia bins ================================"
    for host in ${OKCHAIN_TESTNET_ALL_NODE[@]}
    do
         downloadgaia ${host}
    done

    echo "================================ move genesis.json ================================"
    for host in ${OKCHAIN_TESTNET_ALL_NODE[@]}
    do
        moveGenesisfile ${host}
    done
}

main
