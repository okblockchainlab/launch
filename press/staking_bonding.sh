#!/usr/bin/env bash

okecho() {
    echo "shell exec: [$@]"
    $@
}

# default params
USER_NUM=50
USER_NAME=admin
OKDEXCLI_HOME=~/.okchaincli
BOND_AMOUNT=10
RPC_NODE=c25
RPC_PORT=26657


while getopts "c:h:u:b:n:" opt; do
  case $opt in
    n)
      echo "RPC_NODE=$OPTARG"
      RPC_NODE=$OPTARG
      ;;
    u)
      echo "USER_NAME=$OPTARG"
      USER_NAME=$OPTARG
      ;;
    b)
      echo "BOND_AMOUNT=$OPTARG"
      BOND_AMOUNT=$OPTARG
      ;;
    c)
      echo "USER_NUM=$OPTARG"
      USER_NUM=$OPTARG
      ;;
    h)
      echo "OKDEXCLI_HOME=$OPTARG"
      OKDEXCLI_HOME=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

RPC_INTERFACE=${RPC_NODE}:${RPC_PORT}
echo "RPC_INTERFACE: $RPC_INTERFACE"

COINS=${BOND_AMOUNT}okb
echo "[${COINS}]"

cnt=0
for line in $(cat /tmp/oper_validators); do
    validators[${cnt}]=${line}
    let cnt++
done

for ((index=0;index<${USER_NUM};index++)) do
    for ((i=0;i<${cnt};i++)) do
        okecho okchaincli tx staking delegate ${validators[${i}]} ${COINS} --from ${USER_NAME}${index} \
        --home ${OKDEXCLI_HOME}${index} --chain-id okchain --node ${RPC_INTERFACE} -y -b block
    done
done