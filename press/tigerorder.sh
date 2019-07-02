#!/bin/bash

CURDIR=`dirname $0`

CONCURRENT_NUM=5
ROUND_NUM=10
BATCH_NUM=10
DEPTH=10
PRICE=0.1
QUANTITY=0.1
TYPE=SELL
TOKENPAIR_NUM=2
HOST=c22:26657

while getopts "P:t:q:p:d:b:c:n:u:" opt; do
  case $opt in
    P)
      echo "TOKENPAIR_NUM=$OPTARG"
      TOKENPAIR_NUM=$OPTARG
      ;;
    t)
      echo "TYPE=$OPTARG"
      TYPE=$OPTARG
      ;;
    q)
      echo "QUANTITY=$OPTARG"
      QUANTITY=$OPTARG
      ;;
    p)
      echo "PRICE=$OPTARG"
      PRICE=$OPTARG
      ;;
    d)
      echo "DEPTH=$OPTARG"
      DEPTH=$OPTARG
      ;;
    b)
      echo "BATCH_NUM=$OPTARG"
      BATCH_NUM=$OPTARG
      ;;
    n)
      echo "ROUND_NUM=$OPTARG"
      ROUND_NUM=$OPTARG
      ;;
    c)
      echo "CONCURRENT_NUM=$OPTARG"
      CONCURRENT_NUM=$OPTARG
      ;;
    u)
      echo "HOST=$OPTARG"
      HOST=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

function sell {
    for ((;;)) do
        tiger order -n $ROUND_NUM -c $CONCURRENT_NUM -t SELL -p $PRICE -q $QUANTITY -b $BATCH_NUM -d $DEPTH -P $TOKENPAIR_NUM \
            -u $HOST >> tigersell.log
    done
}

function buy {
    for ((;;)) do
        tiger order -n $ROUND_NUM -c $CONCURRENT_NUM -t BUY -p $PRICE -q $QUANTITY -b $BATCH_NUM -d $DEPTH -P $TOKENPAIR_NUM \
            -u $HOST >> tigerbuy.log
    done
}

function sell_and_buy {
    for ((;;)) do
        tiger order -n $ROUND_NUM -c $CONCURRENT_NUM -t SELL -p $PRICE -q $QUANTITY -b $BATCH_NUM -d $DEPTH -P $TOKENPAIR_NUM \
            -u $HOST >> tigersell.log
        tiger order -n $ROUND_NUM -c $CONCURRENT_NUM -t BUY -p $PRICE -q $QUANTITY -b $BATCH_NUM -d $DEPTH -P $TOKENPAIR_NUM \
            -u $HOST >> tigerbuy.log
    done
}

if [ "${!#}" == "sell" ];then
    sell
elif [ "${!#}" == "buy" ];then
    buy
elif [ "${!#}" == "sell_buy" ];then
    sell_and_buy
fi