#!/usr/bin/env bash
# run in ubuntu with root

. home_okchaind.profile

function downloadGaia {
    cosmosbinpath=/root/gaia_test/cosmosbins
    if [[ ! -d ${cosmosbinpath} ]]; then
        mkdir -p ${cosmosbinpath}
        git clone -b ${1} ${COSMOS_BINS_GIT} ${cosmosbinpath}
    else
        cd ${cosmosbinpath}
        git checkout ${1}
    fi

    #s=`go env | grep GOBIN | sed 's/\"//g'`
    #GOBINPATH=${s##*=}
    cp -f ${cosmosbinpath}/gaiad /usr/local/go/bin
    cp -f ${cosmosbinpath}/gaiacli /usr/local/go/bin
    echo "gaiad version `/usr/local/go/bin/gaiad version` , gaiacli version `/usr/local/go/bin/gaiacli version` "
}

downloadGaia ${1}