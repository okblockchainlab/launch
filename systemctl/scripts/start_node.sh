#!/bin/bash

. $HOME/okchain/launch/systemctl/scripts/okchaind.profile

SEED_NODE=false

LOCAL_IP=`ifconfig  | grep ${IP_PREFIX} | awk '{print $2}' | cut -d: -f2`

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
        ln -s /data ${HOME_DAEMON}
        scp -r ${SCP_TAG}@${OKCHAIN_TESTNET_SEED_NODES[0]}:${HOME_DAEMON}/${host}/* ${HOME_DAEMON}/
        scp -r ${SCP_TAG}@${OKCHAIN_TESTNET_SEED_NODES[0]}:${HOME_CLI}/${host}/ ${HOME_CLI}/
    fi
fi

. ${HOME_DAEMON}/profile

EXTERNAL_IP=`curl ifconfig.me`

if [ ${ROLE} = "VAL" ];then
    ${OKCHAIN_DAEMON} start --home ${HOME_DAEMON} \
        --p2p.addr_book_strict=false \
        --log_stdout=false \
        --log_level *:info \
        --log_file ${HOME_DAEMON}/okchaind.log \
        --db_backend goleveldb \
        --prof_laddr 0.0.0.0:6060 \
        --p2p.laddr tcp://${LOCAL_IP}:26656 \
        --p2p.pex=false  \
        --p2p.persistent_peers ${SENTRY_NODES}
elif [ ${ROLE} = "SEED" ];then
    ${OKCHAIN_DAEMON} start --home ${HOME_DAEMON} \
        --p2p.seeds ${SEED_NODE_ID}@${SEED_NODE_URL} \
        --p2p.addr_book_strict=false \
        --p2p.seed_mode=true \
        --log_stdout=false \
        --log_level *:info \
        --log_file ${HOME_DAEMON}/okchaind.log \
        --db_backend goleveldb \
        --prof_laddr 0.0.0.0:6060 \
        --p2p.laddr tcp://0.0.0.0:26656 \
        --p2p.external_address tcp://${EXTERNAL_IP}:26656
elif [ ${ROLE} = "SENTRY" ];then
    ${OKCHAIN_DAEMON} start --home ${HOME_DAEMON} \
        --p2p.seeds ${SEED_NODE_ID}@${SEED_NODE_URL} \
        --p2p.addr_book_strict=false \
        --log_stdout=false \
        --log_level *:info \
        --log_file ${HOME_DAEMON}/okchaind.log \
        --db_backend goleveldb \
        --prof_laddr 0.0.0.0:6060 \
        --p2p.laddr tcp://0.0.0.0:26656 \
        --p2p.external_address tcp://${EXTERNAL_IP}:26656 \
        --p2p.private_peer_ids ${VAL_NODE_IDS} \
        --p2p.persistent_peers ${VAL_NODES}
elif [ ${ROLE} = "STREAM" ];then
    ${OKCHAIN_DAEMON} start --home ${HOME_DAEMON} \
        --p2p.seeds ${SEED_NODE_ID}@${SEED_NODE_URL} \
        --p2p.addr_book_strict=false \
        --log_stdout=false \
        --log_level *:info \
        --log_file ${HOME_DAEMON}/okchaind.log \
        --db_backend goleveldb \
        --prof_laddr 0.0.0.0:6060 \
        --p2p.laddr tcp://0.0.0.0:26656 \
        --p2p.external_address tcp://${EXTERNAL_IP}:26656 \
        --backend.enable_backend=true \
        --stream_engine="analysis&mysql&rm-j6c49h8htkc5dfp1535910.mysql.rds.aliyuncs.com:3306,notify&redis&redis://:5LA4GZokZG1N@r-j6cba24f845403b4.redis.rds.aliyuncs.com:6379" \
        --worker-id="worker${LOCAL_IP}" \
        --redis_scheduler=redis://:5LA4GZokZG1N@r-j6cba24f845403b4.redis.rds.aliyuncs.com:6379 \
        --redis_lock=redis://:5LA4GZokZG1N@r-j6cba24f845403b4.redis.rds.aliyuncs.com:6379
else
    ${OKCHAIN_DAEMON} start --home ${HOME_DAEMON} \
        --p2p.seeds ${SEED_NODE_ID}@${SEED_NODE_URL} \
        --p2p.addr_book_strict=false \
        --log_stdout=false \
        --log_level *:info \
        --log_file ${HOME_DAEMON}/okchaind.log \
        --db_backend goleveldb \
        --prof_laddr 0.0.0.0:6060 \
        --p2p.laddr tcp://0.0.0.0:26656 \
        --p2p.external_address tcp://${EXTERNAL_IP}:26656
fi