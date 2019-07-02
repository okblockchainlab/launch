#!/bin/bash

while getopts "bcp:e:" opt; do
  case $opt in
    c)
      echo "GIT_CLONE"
      GIT_CLONE="true"
      ;;
    b)
      echo "REBUILD_BINARIES"
      REBUILD_BINARIES="true"
      ;;
    p)
      echo "PROFILE=$OPTARG"
      PROFILE=$OPTARG
      ;;
    e)
      echo "ENV_TYPE=$OPTARG"
      ENV_TYPE=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

if  [ ! -n "$ENV_TYPE" ] ;then
    echo "git.sh you must input -e!"
    exit
fi
PROFILE=${ENV_TYPE}_okchaind.profile
. ./${PROFILE}

function gitclone {
echo git clone@$1
${SSH}@$1 << eeooff
    sudo rm -rf ${OKCHAIN_LAUNCH_TOP}
    git clone ${LAUNCH_GIT} ${OKCHAIN_LAUNCH_TOP}
    cd ${OKCHAIN_LAUNCH_TOP}
    git checkout v0.1

    cd ${OKCHAIN_LAUNCH_TOP}/systemctl/binary/
    git clone ${OKBINS_GIT}
    git checkout v0.1
    cd okbins
    ../unzip.sh

    mv ${OKCHAIN_LAUNCH_TOP}/systemctl/binary/launch ${OKCHAIN_LAUNCH_TOP}/
    cd ${OKCHAIN_LAUNCH_TOP}/systemctl/scripts
    ./service.sh ${ENV_TYPE}
eeooff
echo done!
}


function rebuild_and_push {
ssh root@192.168.13.116 << eeooff
    source /root/env.sh
    cd /root/go/src/github.com/ok-chain/okchain
    git stash
    git pull
    git checkout v0.1
    git pull
    git branch
    make install

    cd /root/go/src/github.com/ok-chain/okchain/launch
    go build

    cd /root/go/src/github.com/cosmos/launch
    git stash
    git pull
    git checkout v0.1
    git pull
    git branch

    if [ ! -d "/root/go/src/github.com/cosmos/launch/systemctl/binary/okbins_${ENV_TYPE}" ]; then
        git clone ${OKBINS_GIT} /root/go/src/github.com/cosmos/launch/systemctl/binary/okbins_${ENV_TYPE}
    fi
    cd /root/go/src/github.com/cosmos/launch/systemctl/binary/okbins_${ENV_TYPE}
    git stash
    git pull
    git checkout v0.1
    git pull
    git branch
    cp /usr/local/go/bin/okchaind .
    cp /usr/local/go/bin/okchaincli .
    cp /root/go/src/github.com/ok-chain/okchain/launch/launch .
    ../zip.sh
    ../gitpush.sh
eeooff
echo done!
}

function pull_update {
echo git pull@$1
${SSH}@$1 << eeooff
    cd ${OKCHAIN_LAUNCH_TOP}
    git stash
    git pull
    git checkout v0.1
    git pull
    git branch

    cd ${OKCHAIN_LAUNCH_TOP}/systemctl/binary/okbins
    git stash
    git pull
    git checkout v0.1
    git pull
    git branch
    ../unzip.sh

    mv ${OKCHAIN_LAUNCH_TOP}/systemctl/binary/launch ${OKCHAIN_LAUNCH_TOP}/
    cd ${OKCHAIN_LAUNCH_TOP}/systemctl/scripts
    ./service.sh ${ENV_TYPE}
eeooff
echo done!
}

function main {
    if [ ! -z "${GIT_CLONE}" ];then
        for host in ${OKCHAIN_TESTNET_DEPLOYED_HOSTS[@]}
        do
            gitclone ${host}
        done

        exit
    fi

    if [ ! -z "${REBUILD_BINARIES}" ];then
        rebuild_and_push
    fi

    for host in ${OKCHAIN_TESTNET_DEPLOYED_HOSTS[@]}
    do
        pull_update ${host}
    done
}

main