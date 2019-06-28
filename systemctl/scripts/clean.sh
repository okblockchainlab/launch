#!/usr/bin/env bash

. ./okchaind.profile

rm -rf ${HOME_DAEMON}
rm -rf ${HOME_CLI}
rm -rf /data/*
# ${OKCHAIN_DAEMON} unsafe-reset-all
