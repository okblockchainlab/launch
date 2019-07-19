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
    gaiapath=$HOME/gaia_test/gaia
    rm -rf ${gaiapath}
    git clone -b ${VERSION} ${GAIA_SOURCE_GIT} ${gaiapath}

    cd ${gaiapath}
    go mod vendor
    go mod verify
    git add .
    git commit -m "go mod vendor"
    git remote add okblockchainlab ${GAIA_OKLAB_GIT}
    git push okblockchainlab ${VERSION}
}

main