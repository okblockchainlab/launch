#!/usr/bin/env bash

. home_okchaind.profile

for host in ${OKCHAIN_TESTNET_ALL_NODE[@]}
do
    ssh-copy-id -i ~/.ssh/id_rsa root@${host}
done