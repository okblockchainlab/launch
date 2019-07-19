#!/usr/bin/env bash

#run in mac

. ../init_all.profile
. ../init_goenv.profile

VERSION="master"

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

function main {
    cosmospath=$HOME/gaia_test/cosmos-sdk
    rm -rf ${cosmospath}
    git clone -b ${VERSION} ${COSMOS_SOURCE_GIT} ${cosmospath}

    cd ${cosmospath}
    go mod vendor
    go mod verify
    git add .
    git commit -m "go mod vendor"
    git remote add okblockchainlab ${COSMOS_OKLAB_GIT}
    git push okblockchainlab ${VERSION}
}

main