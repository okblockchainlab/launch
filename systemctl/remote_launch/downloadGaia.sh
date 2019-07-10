#!/usr/bin/env bash

function downloadGaia {
    cosmosbinpath=/root/cosmos/cosmosbins
    rm -rf ${cosmosbinpath}
    mkdir -p ${cosmosbinpath}
    git clone -b ${1} ${COSMOS_BINS_GIT} ${cosmosbinpath}
}

downloadGaia ${1}