#!/usr/bin/env bash
# run in local

. init_all.profile
. init_ubuntu.profile

while getopts "v:" opt; do
  case ${opt} in
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

function genGenesisfile {
     echo "====================== move launch/genesis.json ======================"
${SSH}@${1} << eeooff
    rm -rf /root/.gaiad
    mkdir -p ${GENESIS_PATH}
    ${GOBINPATH}/gaiad init node0

    exit
eeooff
}

function moveGenesisfile {
     echo "====================== move launch/genesis.json ======================"
${SSH}@${1} << eeooff
    scp -f ${GENESIS_PATH} root@okchain16:${GENESIS_PATH}/genesis.json

    exit
eeooff
}

#2.download bins in every host
#3.
function main {
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

    echo "================================ generate genesis.json ================================"
    for host in ${OKCHAIN_TESTNET_ALL_NODE[0]}
    do
        genGenesisfile ${host}
    done

    echo "================================ move genesis.json ================================"
    for host in ${OKCHAIN_TESTNET_ALL_NODE[@]}
    do
        if [[ ! ${host} == "okchain16" ]]; then
            moveGenesisfile ${host}
        fi
    done
}

main
