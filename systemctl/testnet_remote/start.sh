#!/bin/bash

TOKEN_PROFILE=token.profile
ENV_TYPE=cloud

while getopts "oqrcstap:e:" opt; do
  case $opt in
    q)
      echo "QUERY"
      QUERY="true"
      ;;
    r)
      echo "RESTART"
      RESTART="true"
      ;;
    c)
      echo "CLEAN"
      CLEAN="true"
      ;;
    p)
      echo "PROFILE=$OPTARG"
      PROFILE=$OPTARG
      ;;
    e)
      echo "ENV_TYPE=$OPTARG"
      ENV_TYPE=$OPTARG
      ;;
    t)
      echo "TOKEN"
      TOKEN="true"
      ;;
    s)
      echo "STOP"
      STOP="true"
      ;;
    a)
      echo "ACTIVE"
      ACTIVE="true"
      ;;
    o)
      echo "ORDER"
      ORDER="true"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

PROFILE=${ENV_TYPE}_okchaind.profile
. ./${PROFILE}
. ./${TOKEN_PROFILE}

start_node() {
    echo start_node@$1
${SSH}@$1 << eeooff
    sudo systemctl stop okchaind
    sudo systemctl start okchaind
    sudo systemctl status okchaind

    exit
eeooff
}

gen_file() {
    echo gen_file@$1
${SSH}@$1 << eeooff
    cd ${OKCHAIN_LAUNCH_TOP}/systemctl/scripts
    ./genefile.sh

    exit
eeooff
}

query_node() {
    echo query_node@$1
${SSH}@$1 << eeooff
    sudo systemctl status okchaind
    exit
eeooff
}

function clean {
    echo clean@$1
${SSH}@$1 << eeooff
    cd ${OKCHAIN_LAUNCH_TOP}/systemctl/scripts
    ./clean.sh
    exit
eeooff
}

function stop {
    echo stop@$1
${SSH}@$1 << eeooff
    sudo systemctl stop okchaind
    sudo systemctl status okchaind
    exit
eeooff
}


function order {
    for ((j=0; j<10; j++))
    do
        for ((i=0; i<${#TOKENS[@]}; i++))
        do
            okchaincli tx order new ${TOKENS[i]}_okb BUY 0.1 0.1 -y --from captain --node ${TESTNET_RPC_INTERFACE}
        done
    done
}

function stop_and_cleanup {
    echo stop@$1
${SSH}@$1 << eeooff
    sudo systemctl stop okchaind
    sudo systemctl status okchaind
    cd ${OKCHAIN_LAUNCH_TOP}/systemctl/scripts
    ./clean.sh
    exit
eeooff
}

exe_stop() {
        for host in ${OKCHAIN_TESTNET_ALL_NODE[@]}
        do
            stop ${host}
            if [ ! -z "${CLEAN}" ];then
                clean ${host}
            fi
        done
        exit
}

exe_query() {
        for host in ${OKCHAIN_TESTNET_ALL_NODE[@]}
        do
            query_node ${host}
        done
        exit
}

run() {

    echo "========== step1: stop adn clean node =========="
    for host in ${OKCHAIN_TESTNET_ALL_NODE[@]}
    do
        if [ ! -z "${RESTART}" ];then
            stop ${host}
        fi

        if [ ! -z "${CLEAN}" ];then
            clean ${host}
        fi
    done
    echo "========== step2: generate file =========="
    if [ ! -z "${CLEAN}" ];then
        gen_file ${OKCHAIN_TESTNET_ALL_NODE[0]}
        echo "===== waiting create file 10s... ====="
        sleep 10
    fi
    echo "========== step3: start node =========="
    for host in ${OKCHAIN_TESTNET_ALL_NODE[@]}
    do
        start_node ${host}
    done
}


function main {

cat>env.profile<<EOF
ENV_TYPE=${ENV_TYPE}
EOF
    if [ ! -z "${ORDER}" ];then
        order
        exit
    fi

    if [ ! -z "${TOKEN}" ];then
        ./icobysuffix.sh
        exit
    fi

    if [ ! -z "${STOP}" ];then
        exe_stop
    fi

    if [ ! -z "${QUERY}" ];then
        exe_query
    fi

    run
    exe_query
}

main