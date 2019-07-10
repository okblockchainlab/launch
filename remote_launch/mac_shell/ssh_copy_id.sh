#!/usr/bin/env bash


. ../init_all.profile

for host in ${OKCHAIN_TESTNET_ALL_NODE[@]}
do
    ssh-copy-id -i ~/.ssh/id_rsa root@${host}
done