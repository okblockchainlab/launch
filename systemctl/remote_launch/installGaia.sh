#!/usr/bin/env bash

. home_okchaind.profile

function makeInstall {
    cosmospath=${GOPATH}/src/github.com/okblockchainlab/cosmos-sdk
    if [[ ! -d ${cosmospath} ]]; then
        mkdir -p ${cosmospath}
        git clone ${COSMOS_GIT} ${cosmospath}
    fi

    cd ${cosmospath}
    git checkout -b ${1} remotes/origin/release/${1}
    git checkout ${1}
    make tools install
}

function pushGaia {
    cosmosbinpath=${GOPATH}/src/github.com/okblockchainlab/cosmosbins
    if [[ ! -d ${cosmosbinpath} ]]; then
        mkdir -p ${cosmosbinpath}
        git clone ${COSMOS_BINS_GIT} ${cosmosbinpath}
    fi

    cd ${cosmosbinpath}
    git checkout -b ${1}

    gaiadpath=`which gaiad`
    gaiaclipath=`which gaiacli`
    echo "====================== copy gaia bins to ./cosmosbins ====================="
    cp -f ${gaiadpath} ${cosmosbinpath}
    cp -f ${gaiaclipath} ${cosmosbinpath}

    echo "====================== push gaia bins to github ====================="
    git add .
    git commit -a -m "rebuild gaiad bin ${1} in `date "+%G-%m-%d %H:%M:%S"`"
    git push origin ${1}:${1}
}

#1.download cosmos-sdk@v & install gaiad & gaiacli & upload bins to github.com/okblockchainlab
function main {
    makeInstall ${1}
    pushGaia ${1}
}

main ${1}