#!/usr/bin/env bash

. home_okchaind.profile

function gitclone {
     echo install $1
      in $2
${SSH}@$1 << eeooff
    if [[ ! -d ${COSMOS_BINS_TOP} ]]; then
        mkdir -p ${COSMOS_BINS_TOP}
        git clone ${COSMOS_BINS_GIT} ${COSMOS_BINS_TOP}
    fi

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
