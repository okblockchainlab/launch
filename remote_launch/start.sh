#!/usr/bin/env bash
# run in local

. init_all.profile
. init_ubuntu.profile

UPDATELAUNCH=0
DOWNLOADGAIA=0
GENRERATEFILE=0
STARTGAIA=0
KILLGAIA=0
VERSION="v0.35.0"

while getopts "ugfskv:" opt; do
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
    k)
      KILLGAIA=1
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
    cd ${LAUNCH_PATH}/remote_launch
    sh generateLocal.sh

    exit
eeooff
}

function scpGensisFile {
${SSH}@${1} << eeooff | grep "kkk" #fitler useless ssh login message
    rm -rf /root/gaianode
    scp -r root@${2}:/root/testnet/node${3} /root/gaianode

    exit
eeooff
}

function startgaia {
${SSH}@${1} << eeooff
    PATH=$PATH:/usr/local/go/bin
    gaiad version
    gaiad start --home gaianode/gaiad/ --log_level *:info --p2p.laddr tcp://${1}:16656 --rpc.laddr tcp://0.0.0.0:16657 > /root/gaianode/testchain.log &

    exit
eeooff
}

function startgaiaone {
${SSH}@${1} << eeooff
    PATH=$PATH:/usr/local/go/bin
    gaiad version
    gaiad start --home gaianode/gaiad/ --log_level *:info > /root/gaianode/testchain.log &

    exit
eeooff
}

function killgaia {
${SSH}@${1} << eeooff
    cd ${LAUNCH_PATH}/remote_launch
    sh killGaia.sh

    exit
eeooff
}

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
        from=${OKCHAIN_TESTNET_ALL_NODE[0]}
        generateGenesisfile ${from}
        for i in $(seq 1 3);
        do
             to=${OKCHAIN_TESTNET_ALL_NODE[${i}]}
             echo "====================== distribute ./node${i}/ to ${to}:/root/gaianode======================"
             scpGensisFile ${to} ${from} ${i}
        done
    fi

    if [[ ${STARTGAIA} -eq 1 ]];then
        echo "================================ start testnet ================================"
        startgaiaone ${OKCHAIN_TESTNET_ALL_NODE[0]}
        for i in $(seq 1 3);
        do
             startgaia ${OKCHAIN_TESTNET_ALL_NODE[${i}]}
        done
    fi

    if [[ ${KILLGAIA} -eq 1 ]];then
        echo "================================ kill gaia ================================"
        for host in ${OKCHAIN_TESTNET_ALL_NODE[@]}
        do
            killgaia ${host}
        done
    fi

}

main
