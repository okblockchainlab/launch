#!/usr/bin/env bash

CURDIR=`dirname $0`

# default params
USER_NUM=50
USER_NAME=user
OKDEXCLI_HOME=~/.okchaincli
BALANCE=2000
RPC_NODE=c25
RPC_PORT=26657


while getopts "c:h:u:b:n:NR" opt; do
  case $opt in
    N)
      echo "CREATE_NEW_USER"
      CREATE_NEW_USER="Y"
      ;;
    R)
      echo "RECOVER_USER"
      RECOVER_USER="Y"
      ;;
    n)
      echo "RPC_NODE=$OPTARG"
      RPC_NODE=$OPTARG
      ;;
    u)
      echo "USER_NAME=$OPTARG"
      USER_NAME=$OPTARG
      ;;
    b)
      echo "BALANCE=$OPTARG"
      BALANCE=$OPTARG
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


init() {
    COINS=${BALANCE}okb
    echo "[${COINS}]"
}

okecho() {
    echo "shell exec: [$@]"
    $@
}

main() {

    init

    if [ ! -z "${CREATE_NEW_USER}" ]; then
        okecho ${CURDIR}/genacc.sh -u ${USER_NAME} -c ${USER_NUM} -r -h ${OKDEXCLI_HOME}
        sleep 5
    fi

    if [ ! -z "${RECOVER_USER}" ]; then
        okecho ${CURDIR}/recovacc.sh -u ${USER_NAME} -c ${USER_NUM} -r -h ${OKDEXCLI_HOME}
        sleep 5
    fi

    okchaincli keys add --recover captain -y \
        -m "puzzle glide follow cruel say burst deliver wild tragic galaxy lumber offer"

    for ((index=0;index<${USER_NUM};index++)) do
        receiver=$(okchaincli keys show ${USER_NAME}${index} -a --home ${OKDEXCLI_HOME}${index})
        okecho okchaincli tx send ${receiver} ${COINS} --from captain -y --chain-id okchain --node ${RPC_INTERFACE}
    done

    sleep 5

    for ((index=0;index<${USER_NUM};index++)) do
        res=$(okchaincli query account $(okchaincli keys show ${USER_NAME}${index} -a --home ${OKDEXCLI_HOME}${index}) \
            --node ${RPC_INTERFACE}|grep Coins)
        echo "${USER_NAME}${index} ${res}"
    done

    res=$(okchaincli query account $(okchaincli keys show captain -a) --node ${RPC_INTERFACE} |grep Coins)
    echo "captain ${res}"
}

main