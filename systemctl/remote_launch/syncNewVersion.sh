#!/usr/bin/env bash
#run in ubuntu with root

. home_okchaind.profile

function main {
    cosmospath=~cosmos/cosmos-sdk
    rm -rf ${cosmospath}
    git clone -b release/${1} ${SOURCE_COSMOS_GIT} ${cosmospath}
    cd ${cosmospath}

    git remote add okblockchainlab ${COSMOS_GIT}
    git push okblockchainlab release/${1}
}

main ${1}