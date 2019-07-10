#!/usr/bin/env bash
# run in ubuntu with root

. init_all.profile
. init_ubuntu.profile

function makeInstall {
    cosmospath=${COSMOS_PATH}
    rm -rf ${cosmospath}
    git clone -b release/${1} ${COSMOS_SOURCE_GIT} ${cosmospath}
    cd ${cosmospath}

    echo "====================== rebuild gaia with version `git branch` ======================"
    make tools install
}

function pushGaia {
    echo "====================== git checkout branch ${1} ====================="
    cosmosbinpath=${COSMOSBINS_PATH}
    if [[ ! -d ${cosmosbinpath} ]]; then
        mkdir -p ${cosmosbinpath}
        git clone ${COSMOS_BINS_GIT} ${cosmosbinpath}
    fi

    cd ${cosmosbinpath}
    git checkout -b ${1}

    echo "====================== copy new gaia bins to ${cosmosbinpath} ====================="
    gaiadpath=`which gaiad`
    gaiaclipath=`which gaiacli`
    cp -f ${gaiadpath} ${cosmosbinpath}
    cp -f ${gaiaclipath} ${cosmosbinpath}

    echo "====================== push new gaia bins to gitlab ====================="
    git add .
    git commit -m "rebuild gaia bin ${1} in `date "+%G-%m-%d %H:%M:%S"`"
    git push origin ${1}:${1}
}

#1.download cosmos-sdk@v & install gaiad & gaiacli & upload bins to github.com/okblockchainlab
function main {
    makeInstall ${1}
    pushGaia ${1}
}

main ${1}