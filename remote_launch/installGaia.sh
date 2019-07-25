#!/usr/bin/env bash
# run in ubuntu with root

. init_all.profile
. init_ubuntu.profile

VERSION="v0.35.0"

while getopts "v:" opt; do
  case ${opt} in
    v)
      VERSION="release/$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

function makeInstall {
    cosmospath=${COSMOS_PATH}
    rm -rf ${cosmospath}
    git clone -b ${VERSION} ${COSMOS_OKLAB_GIT} ${cosmospath}

    echo "====================== rebuild gaia with version ${VERSION} ======================"
    cd ${cosmospath}
    make tools install
    VERSION="`gaiad version`"
}

function pushGaia {
    echo "====================== git checkout branch ${VERSION} ====================="
    cosmosbinpath=${COSMOSBINS_PATH}
    if [[ ! -d ${cosmosbinpath} ]]; then
        mkdir -p ${cosmosbinpath}
        git clone ${COSMOS_BINS_GIT} ${cosmosbinpath}
    fi

    cd ${cosmosbinpath}
    git checkout -b ${VERSION}

    echo "====================== copy new gaia bins to ${cosmosbinpath} ====================="
    gaiadpath=`which gaiad`
    gaiaclipath=`which gaiacli`
    cp -f ${gaiadpath} ${cosmosbinpath}
    cp -f ${gaiaclipath} ${cosmosbinpath}

    echo "====================== push new gaia bins ${VERSION} to gitlab ====================="
    git add .
    git commit -m "rebuild gaia bin ${VERSION} in `date "+%G-%m-%d %H:%M:%S"`"
    git push origin ${VERSION}:${VERSION}
}

#1.download cosmos-sdk@v & install gaiad & gaiacli & upload bins to github.com/okblockchainlab
function main {
    makeInstall
    pushGaia
}
