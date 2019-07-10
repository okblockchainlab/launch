#!/usr/bin/env bash


. init_all.profile
. init_ubuntu.profile

function downloadLaunch {
    if [[ ! -d ${LAUNCH_PATH} ]]; then
       git clone -b cosmos ${LAUNCH_GIT} ${LAUNCH_PATH}
    else
       cd ${LAUNCH_PATH}
       git checkout cosmos
       git pull origin cosmos
    fi
}

downloadLaunch