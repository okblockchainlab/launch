#!/usr/bin/env bash

. ./env.profile
PROFILE=${ENV_TYPE}_okchaind.profile

while getopts "sr" opt; do
  case $opt in
    s)
      echo "STOP TIGER"
      STOP="true"
      ;;
    b)
      echo "RESTART TIGER"
      RESTART="true"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

. ./${PROFILE}


function stoptiger {
    echo stop $1 $2
    if [ "$2" == "HK" ];then
        OKCHAIN_LAUNCH_TOP=/home/ubuntu/okchain/launch
        SSH=${SSHHK}
    elif [ "$2" == "LOCAL" ];then
        OKCHAIN_LAUNCH_TOP=/root/go/src/github.com/cosmos/launch
        SSH=${SSHLOCAL}
    elif [ "$2" == "JP" ];then
        OKCHAIN_LAUNCH_TOP=/home/ubuntu/okchain/launch
        SSH=${SSH}
    fi

echo ${SSH}
${SSH}@$1 << eeooff
    cd ${OKCHAIN_LAUNCH_TOP}/press
    ./killbyname.sh tiger
    rm -f tige*.log
eeooff
}

function stop {
    for host in ${OKCHAIN_TESTNET_HK_DEPLOYED_HOSTS[@]}
    do
        stoptiger ${host} HK
    done

#    for host in ${OKCHAIN_TESTNET_DEPLOYED_HOSTS[@]}
#    do
#        stoptiger ${host} JP
#    done

#    for host in ${OKCHAIN_TESTNET_LOCAL_HOSTS[@]}
#    do
#        stoptiger ${host} LOCAL
#    done
}


function starttiger {
    echo start $1 $2
    if [ "$2" == "HK" ];then
        OKCHAIN_LAUNCH_TOP=/home/ubuntu/okchain/launch
        SSH=${SSHHK}
    elif [ "$2" == "LOCAL" ];then
        OKCHAIN_LAUNCH_TOP=/root/go/src/github.com/cosmos/launch
        SSH=${SSHLOCAL}
    fi

    if [ "$3" == "sell" ];then
        CMD="nohup ./tigerorder.sh -c 100 -n 1000000 -b 2 -d 1 -P 3 -u c21:26657,c22:26657,c23:26657,c24:26657 sell > tiger.txt 2>&1 &"
    elif [ "$3" == "buy" ];then
        CMD="nohup ./tigerorder.sh -c 100 -n 1000000 -b 2 -d 1 -P 3 -u c21:26657,c22:26657,c23:26657,c24:26657 buy > tiger.txt 2>&1 &"
    elif [ "$3" == "sell_buy" ];then
        CMD="nohup ./tigerorder.sh -c 200 -n 10 -b 2 -d 1 -P 3 -u c21:26657,c22:26657,c23:26657,c24:26657 sell_buy > tiger.txt 2>&1 &"
    elif [ "$3" == "send" ];then
        CMD="nohup ./tigersend.sh -c 300 -n 10000000 > tiger.txt 2>&1 &"
    fi

echo ${SSH} ${CMD}
${SSH}@$1 "cd ${OKCHAIN_LAUNCH_TOP}/press; source /root/env.sh; ${CMD}"
}

function start {
    for host in ${OKCHAIN_TESTNET_HK_DEPLOYED_HOSTS[@]}
    do
        starttiger ${host} HK $1
    done

#    for host in ${OKCHAIN_TESTNET_LOCAL_HOSTS[@]}
#    do
#        starttiger ${host} LOCAL $1
#    done
}


function main {
    if [ ! -z "${STOP}" ];then
        stop
        echo "stop done"
        exit
    fi

    start $1
    echo "start done"
}

main $1