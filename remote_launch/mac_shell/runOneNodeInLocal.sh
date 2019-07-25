#!/usr/bin/env bash


. ../init_all.profile
. ../init_goenv.profile

VERSION="master"
REBUILD=0
GENERATE=0
STARTNODE=0
KILLNODE=0

while getopts "rgskv:" opt; do
  case ${opt} in
    r)
      REBUILD=1
      ;;
    g)
      GENERATE=1
      ;;
    s)
      STARTNODE=1
      ;;
    k)
      KILLNODE=1
      ;;
    v)
      VERSION="release/$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

function makeInstall {
    cosmospath=$HOME/gaia_test/cosmos-sdk
    rm -rf ${cosmospath}
    git clone -b ${VERSION} ${COSMOS_SOURCE_GIT} ${cosmospath}

    echo "====================== rebuild gaia with version ${VERSION} ======================"
    cd ${cosmospath}
    make tools install
    echo `which gaiad` `gaiad version`
}

function generate {
    rm -rf $HOME/gaia_test/gaianod
    gaiad testnet --v 1 --output-dir $HOME/gaia_test/gaianode --chain-id testchain --starting-ip-address 127.0.0.1
}

function start {
    nohup gaiad start --home $HOME/gaia_test/gaianode/node0/gaiad/ --log_level *:info >> $HOME/gaia_test/gaianode/node0/testchain.log 2>&1 &
}

function killnode {
    pid=`ps -ef|grep gaiad|grep -v grep | awk '{print $2}'`
    echo "kill gaiad ,pid: $pid"
    kill ${pid}
}

function main {
    if [[ ${REBUILD} -eq 1 ]];then
        makeInstall
    fi

    if [[ ${GENERATE} -eq 1 ]];then
        generate
    fi

    if [[ ${STARTNODE} -eq 1 ]];then
        start
    fi

    if [[ ${KILLNODE} -eq 1 ]];then
        killnode
    fi
}

main