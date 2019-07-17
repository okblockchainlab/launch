#!/bin/bash
SHELL_FOLDER=$(dirname "$0")
. ${SHELL_FOLDER}/env.profile
PROFILE=${ENV_TYPE}_okchaind.profile
. ${SHELL_FOLDER}/${PROFILE}

AWS_OKBINS=/home/ubuntu/okchain/launch/systemctl/binary/okbins/

function scp_okbins_to_ali {
    ssh root@okchain16 "scp go/src/github.com/cosmos/launch/systemctl/binary/okbins_${ENV_TYPE}/okchainbins.tar.gz root@47.90.127.245:/root/"
    ssh root@47.90.127.245 "scp -i okchain-dex-test.pem okchainbins.tar.gz ubuntu@52.197.220.161:/home/ubuntu/"
}

function scp_okbins_to_awsJP {
    for host in ${OKCHAIN_TESTNET_DEPLOYED_HOSTS[@]}
    do
        ${SSH}@52.197.220.161 "scp -i okchain-dex-test.pem okchainbins.tar.gz ubuntu@${host}:${AWS_OKBINS}"
    done
}

function scp_okbins_to_awsHK {
    for host in ${OKCHAIN_TESTNET_ALL_HK_NODE[@]}
    do
        ${SSH}@52.197.220.161 "scp -i aws_ok_hongkong.pem okchainbins.tar.gz ubuntu@${host}:${AWS_OKBINS}"
    done
}

function main {
    scp_okbins_to_ali
    scp_okbins_to_awsJP
    scp_okbins_to_awsHK
}

main