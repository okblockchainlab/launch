#!/usr/bin/env bash

okecho() {
    echo "shell exec: [$@]"
    $@
}

# default params
VALIDATOR_NUM=21
USER_NUM=50
USER_NAME=admin
OKDEXCLI_HOME=~/.okchaincli
OKDEXD_HOME=~/.okchaind
SELF_DELEGATE=100
RPC_NODE=c22
RPC_PORT=26657


while getopts "c:h:u:s:n:N:H:" opt; do
  case $opt in
    N)
      echo "VALIDATOR_NUM"
      VALIDATOR_NUM=$OPTARG
      ;;
    n)
      echo "RPC_NODE=$OPTARG"
      RPC_NODE=$OPTARG
      ;;
    u)
      echo "USER_NAME=$OPTARG"
      USER_NAME=$OPTARG
      ;;
    s)
      echo "BONDING_COINS=$OPTARG"
      SELF_DELEGATE=$OPTARG
      ;;
    c)
      echo "USER_NUM=$OPTARG"
      USER_NUM=$OPTARG
      ;;
    h)
      echo "OKDEXCLI_HOME=$OPTARG"
      OKDEXCLI_HOME=$OPTARG
      ;;
    H)
      echo "OKDEXD_HOME=$OPTARG"
      OKDEXD_HOME=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

RPC_INTERFACE=${RPC_NODE}:${RPC_PORT}
echo "RPC_INTERFACE: $RPC_INTERFACE"

COINS=${SELF_DELEGATE}okb
echo "[${COINS}]"

if [ ${VALIDATOR_NUM} -lt ${USER_NUM} ]; then
    v_num=${VALIDATOR_NUM}
else
    v_num=${USER_NUM}
fi

for ((index=0;index<${v_num};index++)) do
    okecho okchaincli tx staking create-validator --amount ${COINS} --pubkey \
    $(okdexd tendermint show-validator --home ${OKDEXD_HOME}${index}) --chain-id okchain --commission-rate 0.1 \
    --commission-max-rate 0.5 --commission-max-change-rate 0.001 --min-self-delegation 1 --moniker node${index} \
    --from ${USER_NAME}${index} -y --home ${OKDEXCLI_HOME}${index} --node ${RPC_INTERFACE} -b block
done