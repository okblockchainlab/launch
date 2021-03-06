#!/bin/bash
. ./env.profile
PROFILE=${ENV_TYPE}_okchaind.profile

while getopts "bcp:" opt; do
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
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

. ./${PROFILE}


#    sudo mkdir -p ${OKCHAIN_LAUNCH_TOP}

function gitclone {
echo git clone@$1
${SSH}@$1 << eeooff
    sudo rm -rf ${OKCHAIN_LAUNCH_TOP}
    git clone ${LAUNCH_GIT} ${OKCHAIN_LAUNCH_TOP}
    cd ${OKCHAIN_LAUNCH_TOP}/systemctl/binary/
    git checkout dev

    git clone ${OKBINS_GIT}
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
    git reset --hard HEAD
    git checkout dev
    git pull
    make install
    make tiger
    make launchcmd

    cd /root/go/src/github.com/cosmos/launch
    git reset --hard HEAD
    git checkout dev
    git pull
    git branch
    if [ ! -d "/root/go/src/github.com/cosmos/launch/systemctl/binary/okbins_${ENV_TYPE}" ]; then
        git clone ${OKBINS_GIT} /root/go/src/github.com/cosmos/launch/systemctl/binary/okbins_${ENV_TYPE}
    fi
    cd /root/go/src/github.com/cosmos/launch/systemctl/binary/okbins_${ENV_TYPE}
#    git reset --hard HEAD~1
    cp /usr/local/go/bin/okchaind .
    cp /usr/local/go/bin/okchaincli .
    cp /usr/local/go/bin/tiger .
    cp /usr/local/go/bin/launch .
    ../zip.sh
#    ../gitpush.sh
eeooff
echo done!
}

function pull_update {
    echo git pull@$1 $2
    if [ "$2" == "HK" ];then
        OKCHAIN_LAUNCH_TOP=/home/ubuntu/okchain/launch
        SSH=${SSHHK}
    fi
echo ${SSH}
${SSH}@$1 << eeooff
    cd ${OKCHAIN_LAUNCH_TOP}
    git stash
    git pull
    git checkout dev
    git branch

    cd ${OKCHAIN_LAUNCH_TOP}/systemctl/binary/okbins
#    git checkout .
#    git pull
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
            OKCHAIN_LAUNCH_TOP=/home/ubuntu/okchain/launch
            gitclone ${host}
        done

        for host in ${OKCHAIN_TESTNET_HK_DEPLOYED_HOSTS[@]}
        do
            OKCHAIN_LAUNCH_TOP=/home/ubuntu/okchain/launch
            SSH=${SSHHK}
            gitclone ${host}
        done

#        for host in ${OKCHAIN_TESTNET_LOCAL_HOSTS[@]}
#        do
#            OKCHAIN_LAUNCH_TOP=/root/go/src/github.com/cosmos/launch
#            SSH=${SSHLOCAL}
#            gitclone ${host}
#        done

        exit
    fi

    if [ ! -z "${REBUILD_BINARIES}" ];then
        rebuild_and_push
        echo "scp okbin.tar.gz to aws Tokyo and aws HongKong"
        ./copy_okbins.sh
    fi

    for host in ${OKCHAIN_TESTNET_DEPLOYED_HOSTS[@]}
    do
        pull_update ${host}
    done

    for host in ${OKCHAIN_TESTNET_HK_DEPLOYED_HOSTS[@]}
    do
        pull_update ${host} HK
    done

#    for host in ${OKCHAIN_TESTNET_LOCAL_HOSTS[@]}
#    do
#    echo ssh ${host}
#ssh root@${host} << eeooff
#        source /root/env.sh
#        cd /root/go/src/github.com/ok-chain/okchain
#        git reset --hard
#        git pull origin dev
#        git checkout dev
#        make install
#        make tiger
#        make launchcmd
#
#        cd /root/go/src/github.com/cosmos/launch
#        git reset --hard
#        git pull origin dev
#        git checkout dev
#        git branch
#eeooff
#    done
}

main