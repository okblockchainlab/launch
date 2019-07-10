#!/usr/bin/env bash

. home_okchaind.profile

function downloadGaia {
    echo "====================== download gaia bins ${1} ======================"
    cosmosbinpath=/root/cosmos/cosmosbins
    rm -rf ${cosmosbinpath}
    mkdir -p ${cosmosbinpath}
    git clone -b ${1} ${COSMOS_BINS_GIT} ${cosmosbinpath}

    cp -f ${cosmosbinpath}/gaiad ${GOBIN}
    cp -f ${cosmosbinpath}/gaiacli ${GOBIN}
    echo "gaiad version `gaiad version` , gaiacli version `gaiacli version` "
}

downloadGaia ${1}