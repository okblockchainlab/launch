#!/usr/bin/env bash

. home_okchaind.profile

function downloadGaia {
    echo "====================== download gaia bins ${1} ======================"
    cosmosbinpath=/root/cosmos/cosmosbins
   if [[ ! -d ${cosmosbinpath} ]]; then
        mkdir -p ${cosmosbinpath}
        git clone -b ${1} ${COSMOS_BINS_GIT} ${cosmosbinpath}
   else
        cd ${cosmosbinpath}
        git checkout -b ${1}
        git pull origin ${1}
   fi

    cp -f ${cosmosbinpath}/gaiad ${GOBIN}
    cp -f ${cosmosbinpath}/gaiacli ${GOBIN}
    echo "gaiad version `gaiad version` , gaiacli version `gaiacli version` "
}

downloadGaia ${1}