#!/usr/bin/env bash
# run in ubuntu with root

. init_all.profile
. init_ubuntu.profile

function downloadGaia {
    cosmosbinpath=${COSMOSBINS_PATH}
    if [[ ! -d ${cosmosbinpath} ]]; then
        mkdir -p ${cosmosbinpath}
        git clone -b ${1} ${COSMOS_BINS_GIT} ${cosmosbinpath}
    else
        cd ${cosmosbinpath}
        git checkout ${1}
    fi

    #s=`go env | grep GOBIN | sed 's/\"//g'`
    #GOBINPATH=${s##*=}
    cp -f ${cosmosbinpath}/gaiad ${GOBINPATH}
    cp -f ${cosmosbinpath}/gaiacli ${GOBINPATH}
    echo "gaiad version `${GOBINPATH}/gaiad version` , gaiacli version `${GOBINPATH}/gaiacli version` "
}

downloadGaia ${1}