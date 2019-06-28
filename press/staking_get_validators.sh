#!/usr/bin/env bash

okecho() {
    echo "shell exec: [$@]"
    $@
}

# default params
RPC_NODE=c25
RPC_PORT=26657

while getopts "n:" opt; do
  case $opt in
    n)
      echo "RPC_NODE=$OPTARG"
      RPC_NODE=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

RPC_INTERFACE=${RPC_NODE}:${RPC_PORT}
echo "RPC_INTERFACE: $RPC_INTERFACE"

okecho okchaincli query staking validators --node ${RPC_INTERFACE} | grep "Operator Address:" | awk -F: '{print $2}' \
| awk '{print $1}' > /tmp/oper_validators