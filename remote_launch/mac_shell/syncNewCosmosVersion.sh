#!/usr/bin/env bash

#run in mac

. ../init_all.profile
. ../init_goenv.profile

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

function main {
    cosmospath=$HOME/gaia_test/cosmos-sdk
    rm -rf ${cosmospath}
    git clone -b ${VERSION} ${COSMOS_SOURCE_GIT} ${cosmospath}

    cd ${cosmospath}
    go mod vendor
    go mod verify
    git add -f vendor
    git add .
    git commit -m "go mod vendor"
    git remote add okblockchainlab ${COSMOS_OKLAB_GIT}
    git push okblockchainlab ${VERSION}
}

main