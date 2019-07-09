#!/usr/bin/env bash
#run in mac

. home_okchaind.profile

function main {
    cosmospath=~/cosmos-sdk
    rm -rf ${cosmospath}
    git clone ${SOURCE_COSMOS_GIT} ${cosmospath}
    cd ${cosmospath}

    git checkout -b release/${1} remotes/origin/release/${1}
    git checkout release/${1}
    export GO111MODULE=on
    go mod vendor

    sed -i "" '/vendor/d' .gitignore
    git add .
    git commit -a -m "go mod vendor"

    git remote add okblockchainlab ${COSMOS_GIT}
    git push okblockchainlab release/${1}

}

main ${1}