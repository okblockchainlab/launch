#!/bin/bash

. $HOME/okchain/launch/systemctl/scripts/okchaind.profile

SEED_NODE=false

if [ ${IP_INNET} = true ];then
    LOCAL_IP=`ifconfig  | grep ${IP_PREFIX} | awk '{print $2}' | cut -d: -f2`
    LOCAL_IP_INET=${LOCAL_IP}
else
    LOCAL_IP_INET=`curl ifconfig.me`
    LOCAL_IP=ec2-${LOCAL_IP_INET//./-}.ap-northeast-1.compute.amazonaws.com
fi

if [ ${LOCAL_IP} = "${OKCHAIN_TESTNET_SEED_NODES[0]}" ];then
    SEED_NODE=true
else
    scp ${SCP_TAG}@${OKCHAIN_TESTNET_SEED_NODES[0]}:${OKCHAIN_LAUNCH_TOP}/systemctl/scripts/seednode.profile \
        ${OKCHAIN_LAUNCH_TOP}/systemctl/scripts/
fi

. ${OKCHAIN_LAUNCH_TOP}/systemctl/scripts/seednode.profile

if [ ! -d ${HOME_DAEMON}/config ]; then
    host=${HOSTS_PREFIX}${LOCAL_IP}
    if [ ${LOCAL_IP} = "${OKCHAIN_TESTNET_SEED_NODES[0]}" ];then
        cp -r ${HOME_DAEMON}/${host}/* ${HOME_DAEMON}/
        cp -r ${HOME_CLI}/${host}/* ${HOME_CLI}/
    else
        scp -r ${SCP_TAG}@${OKCHAIN_TESTNET_SEED_NODES[0]}:${HOME_DAEMON}/${host}/ ${HOME_DAEMON}/
        scp -r ${SCP_TAG}@${OKCHAIN_TESTNET_SEED_NODES[0]}:${HOME_CLI}/${host}/ ${HOME_CLI}/
    fi
fi

EXIST=`echo "${OKCHAIN_TESTNET_FULL_NODES[@]}" | grep -wq "${LOCAL_IP}" &&  echo "Yes" || echo "No"`

. $HOME/okchain/launch/systemctl/scripts/okchaind.profile
if [ ${EXIST} = "Yes" ];then
    ${OKCHAIN_DAEMON} start --home ${HOME_DAEMON} \
    --p2p.seeds ${SEED_NODE_ID}@${SEED_NODE_URL} \
    --p2p.addr_book_strict=false \
    --p2p.seed_mode=${SEED_NODE} \
    --log_stdout=false \
    --log_level main:info,*:error \
    --log_file ${HOME_DAEMON}/okchaind.log \
    --prof_laddr 0.0.0.0:6060 \
    --p2p.laddr tcp://${LOCAL_IP}:26656 \
    ${STREAM_ENGINE}
    --db_backend goleveldb \
    --production_mode
else
    ${OKCHAIN_DAEMON} start --home ${HOME_DAEMON} \
    --p2p.seeds ${SEED_NODE_ID}@${SEED_NODE_URL} \
    --p2p.addr_book_strict=false \
    --p2p.seed_mode=${SEED_NODE} \
    --log_stdout=false \
    --log_level main:info,*:error \
    --log_file ${HOME_DAEMON}/okchaind.log \
    --prof_laddr 0.0.0.0:6060 \
    --p2p.laddr tcp://${LOCAL_IP}:26656 \
    --db_backend goleveldb \
    --production_mode
fi

