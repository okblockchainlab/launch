#!/bin/bash

IFS="!!"

. $HOME/okchain/launch/systemctl/scripts/okchaind.profile

rm ${OKCHAIN_LAUNCH_TOP}/gentx/data/gentx-*
ln -s /data ${HOME_DAEMON}

echo "===== init seed node ====="
for ((i=0; i<${#OKCHAIN_TESTNET_SEED_NODES[@]}; i++))
do
    host=${HOSTS_PREFIX}${OKCHAIN_TESTNET_SEED_NODES[i]}
    home_d=${HOME_DAEMON}/${host}
    home_cli=${HOME_CLI}/${host}

    ${OKCHAIN_CLI} keys add --recover captain --home ${home_cli} -y -m "${CAPTAIN_MNEMONIC}"

    ${OKCHAIN_DAEMON} init --chain-id okchain --home ${home_d}

    ${OKCHAIN_CLI} config chain-id okchain --home ${home_cli}
    ${OKCHAIN_CLI} config trust-node true --home ${home_cli}
    ${OKCHAIN_CLI} config indent true --home ${home_cli}

    if [ $i -eq 0 ];then
        echo "===== set seed node info ====="
        seedid=$(${OKCHAIN_DAEMON} tendermint show-node-id --home ${home_d})
        cat>${OKCHAIN_LAUNCH_TOP}/systemctl/scripts/seednode.profile<<EOF
SEED_NODE_ID=${seedid}
SEED_NODE_IP=${OKCHAIN_TESTNET_SEED_NODES[i]}
SEED_NODE_URL=${OKCHAIN_TESTNET_SEED_NODES[i]}:26656
EOF
    fi
done

accounts=""
val_nodes=""
val_node_ids=""
echo "===== init validator node ====="
for ((i=0; i<${#OKCHAIN_TESTNET_VAL_NODES[@]}; i++))
do
    host=${HOSTS_PREFIX}${OKCHAIN_TESTNET_VAL_NODES[i]}
    home_d=${HOME_DAEMON}/${host}
    home_cli=${HOME_CLI}/${host}
    mnemonic=${OKCHAIN_TESTNET_VAL_ADMIN_MNEMONIC[i]}

    ${OKCHAIN_CLI} keys add --recover captain --home ${home_cli} -y -m "${CAPTAIN_MNEMONIC}"
    ${OKCHAIN_CLI} keys add --recover ${host} --home ${home_cli}  -y -m "${mnemonic}"
    
    accounts=${accounts}\"$(${OKCHAIN_CLI} keys show ${host} -a --home ${home_cli})\"": 1000,"

    ${OKCHAIN_DAEMON} init --chain-id okchain --home ${home_d}
    node_id=$(${OKCHAIN_DAEMON} tendermint show-node-id --home ${home_d})
    val_nodes=${val_nodes}${node_id}"@"${OKCHAIN_TESTNET_VAL_NODES[i]}":26656,"
    val_node_ids=${val_node_ids}${node_id}","

    ${OKCHAIN_CLI} config chain-id okchain --home ${home_cli}
    ${OKCHAIN_CLI} config trust-node true --home ${home_cli}
    ${OKCHAIN_CLI} config indent true --home ${home_cli}

    ${OKCHAIN_DAEMON} add-genesis-account $(${OKCHAIN_CLI} keys show ${host} -a --home ${home_cli}) \
        1okb --home ${home_d}
    ${OKCHAIN_DAEMON} gentx --amount 1okb --min-self-delegation 1 --commission-rate 0.1 \
        --commission-max-rate 0.5 --commission-max-change-rate 0.001 \
        --pubkey $(${OKCHAIN_DAEMON} tendermint show-validator --home ${home_d}) \
        --moniker ${host} \
        --name ${host} --home ${home_d} --home-client ${home_cli}
    cp ${home_d}/config/gentx/gentx-*.json ${OKCHAIN_LAUNCH_TOP}/gentx/data
done
cat>${OKCHAIN_LAUNCH_TOP}/accounts/others.json<<EOF
{${accounts%?}}
EOF

echo "===== init full node ====="
for ((i=0; i<${#OKCHAIN_TESTNET_FULL_NODES[@]}; i++))
do
    host=${HOSTS_PREFIX}${OKCHAIN_TESTNET_FULL_NODES[i]}
    home_d=${HOME_DAEMON}/${host}
    home_cli=${HOME_CLI}/${host}

    ${OKCHAIN_CLI} keys add --recover captain --home ${home_cli} -y -m "${CAPTAIN_MNEMONIC}"

    ${OKCHAIN_DAEMON} init --chain-id okchain --home ${home_d}
    node_id=$(${OKCHAIN_DAEMON} tendermint show-node-id --home ${home_d})

    ${OKCHAIN_CLI} config chain-id okchain --home ${home_cli}
    ${OKCHAIN_CLI} config trust-node true --home ${home_cli}
    ${OKCHAIN_CLI} config indent true --home ${home_cli}
done

sentry_nodes=""
echo "===== init sentry node ====="
for ((i=0; i<${#OKCHAIN_TESTNET_SENTRY_NODES[@]}; i++))
do
    host=${HOSTS_PREFIX}${OKCHAIN_TESTNET_SENTRY_NODES[i]}
    home_d=${HOME_DAEMON}/${host}
    home_cli=${HOME_CLI}/${host}

    ${OKCHAIN_CLI} keys add --recover captain --home ${home_cli} -y -m "${CAPTAIN_MNEMONIC}"

    ${OKCHAIN_DAEMON} init --chain-id okchain --home ${home_d}
    node_id=$(${OKCHAIN_DAEMON} tendermint show-node-id --home ${home_d})
    sentry_nodes=${sentry_nodes}${node_id}"@"${OKCHAIN_TESTNET_SENTRY_NODES[i]}":26656,"

    ${OKCHAIN_CLI} config chain-id okchain --home ${home_cli}
    ${OKCHAIN_CLI} config trust-node true --home ${home_cli}
    ${OKCHAIN_CLI} config indent true --home ${home_cli}
done

echo "===== init stream node ====="
for ((i=0; i<${#OKCHAIN_TESTNET_STREAM_NODES[@]}; i++))
do
    host=${HOSTS_PREFIX}${OKCHAIN_TESTNET_STREAM_NODES[i]}
    home_d=${HOME_DAEMON}/${host}
    home_cli=${HOME_CLI}/${host}

    ${OKCHAIN_CLI} keys add --recover captain --home ${home_cli} -y -m "${CAPTAIN_MNEMONIC}"

    ${OKCHAIN_DAEMON} init --chain-id okchain --home ${home_d}
    node_id=$(${OKCHAIN_DAEMON} tendermint show-node-id --home ${home_d})

    ${OKCHAIN_CLI} config chain-id okchain --home ${home_cli}
    ${OKCHAIN_CLI} config trust-node true --home ${home_cli}
    ${OKCHAIN_CLI} config indent true --home ${home_cli}
done

cd ${OKCHAIN_LAUNCH_TOP}/
${OKCHAIN_LAUNCH_TOP}/launch

for host in ${OKCHAIN_TESTNET_SEED_NODES[@]}
do
    cp ${OKCHAIN_LAUNCH_TOP}/genesis.json ${HOME_DAEMON}/${HOSTS_PREFIX}${host}/config
    cat>${HOME_DAEMON}/${HOSTS_PREFIX}${host}/profile<<EOF
VAL_NODES=${val_nodes%?}
VAL_NODE_IDS=${val_node_ids%?}
SENTRY_NODES=${sentry_nodes%?}
ROLE=SEED
EOF
done

for host in ${OKCHAIN_TESTNET_VAL_NODES[@]}
do
    cp ${OKCHAIN_LAUNCH_TOP}/genesis.json ${HOME_DAEMON}/${HOSTS_PREFIX}${host}/config
    cat>${HOME_DAEMON}/${HOSTS_PREFIX}${host}/profile<<EOF
VAL_NODES=${val_nodes%?}
VAL_NODE_IDS=${val_node_ids%?}
SENTRY_NODES=${sentry_nodes%?}
ROLE=VAL
EOF
done

for host in ${OKCHAIN_TESTNET_FULL_NODES[@]}
do
    cp ${OKCHAIN_LAUNCH_TOP}/genesis.json ${HOME_DAEMON}/${HOSTS_PREFIX}${host}/config
    cat>${HOME_DAEMON}/${HOSTS_PREFIX}${host}/profile<<EOF
VAL_NODES=${val_nodes%?}
VAL_NODE_IDS=${val_node_ids%?}
SENTRY_NODES=${sentry_nodes%?}
ROLE=FULL
EOF
done

for host in ${OKCHAIN_TESTNET_SENTRY_NODES[@]}
do
    cp ${OKCHAIN_LAUNCH_TOP}/genesis.json ${HOME_DAEMON}/${HOSTS_PREFIX}${host}/config
    cat>${HOME_DAEMON}/${HOSTS_PREFIX}${host}/profile<<EOF
VAL_NODES=${val_nodes%?}
VAL_NODE_IDS=${val_node_ids%?}
SENTRY_NODES=${sentry_nodes%?}
ROLE=SENTRY
EOF
done

for host in ${OKCHAIN_TESTNET_STREAM_NODES[@]}
do
    cp ${OKCHAIN_LAUNCH_TOP}/genesis.json ${HOME_DAEMON}/${HOSTS_PREFIX}${host}/config
    cat>${HOME_DAEMON}/${HOSTS_PREFIX}${host}/profile<<EOF
VAL_NODES=${val_nodes%?}
VAL_NODE_IDS=${val_node_ids%?}
SENTRY_NODES=${sentry_nodes%?}
ROLE=STREAM
EOF
done