#!/usr/bin/env bash

. ./home_okchaind.profile

function gitclone {
     echo install $1 in $2
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
    exit
eeooff
}


#2.download bins in every host
#3.
function main {
    for host in ${OKCHAIN_TESTNET_ALL_NODE[@]}
    do
         gitclone $1 ${host}
    done
}

main
