#!/usr/bin/env bash

okecho() {
    echo "shell exec: [$@]"
    $@
}

# default params
USER_NUM=500
USER_NAME=admin
OKDEXCLI_HOME=~/.okchaincli
UNBOND_AMOUNT=5
RPC_NODE=c25
RPC_PORT=26657


while getopts "c:h:u:U:n:" opt; do
  case $opt in
    n)
      echo "RPC_NODE=$OPTARG"
      RPC_NODE=$OPTARG
      ;;
    u)
      echo "USER_NAME=$OPTARG"
      USER_NAME=$OPTARG
      ;;
    U)
      echo "UNBOND_AMOUNT=$OPTARG"
      UNBOND_AMOUNT=$OPTARG
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

cnt=0
for line in $(cat /tmp/oper_validators); do
    validators[${cnt}]=${line}
    let cnt++
done

for ((index=0;index<${USER_NUM};index++)) do
    for ((i=0;i<${cnt};i++)) do
        okecho okchaincli tx staking unbond ${validators[${i}]} ${UNBOND_AMOUNT} --from ${USER_NAME}${index} \
        --home ${OKDEXCLI_HOME}${index} --chain-id okchain --node ${RPC_INTERFACE} -y
    done
done