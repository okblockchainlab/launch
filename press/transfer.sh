#!/usr/bin/env bash

#!/bin/bash


PRODUCT=btc_okb
OKDEXCLI_HOME=~/.okchaincli
QUANTITY=0.1
NODE=c22
USER=user

while getopts "n:q:h:c:x:u:" opt; do
  case $opt in
    n)
      echo "NODE=$OPTARG"
      NODE=$OPTARG
      ;;
    q)
      echo "QUANTITY=$OPTARG"
      QUANTITY=$OPTARG
      ;;
    h)
      echo "OKDEXCLI_HOME=$OPTARG"
      OKDEXCLI_HOME=$OPTARG
      ;;
    c)
      echo "CONCURRENT_NUM=$OPTARG"
      CONCURRENT_NUM=$OPTARG
      ;;
    x)
      echo "NUM_PER_THREAD=$OPTARG"
      NUM_PER_THREAD=$OPTARG
      ;;
    u)
      echo "USER=$OPTARG"
      USER=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

ENV="-h ./products/${PRODUCT}/${PRODUCT}"

CAPTAINADDR=`okchaincli keys show captain -a`

okecho() {
    echo "shell exec: [$@]"
    $@
}

round() {
    okecho okchaincli tx send ${CAPTAINADDR} ${QUANTITY}okb \
    --from ${USER} \
    --home ${OKDEXCLI_HOME} \
    --chain-id okchain \
    -y -c ${CONCURRENT_NUM} \
    -x ${NUM_PER_THREAD} --node c21:26657 -b block

    okecho okchaincli tx send ${CAPTAINADDR} ${QUANTITY}okb \
    --from ${USER} \
    --home ${OKDEXCLI_HOME} \
    --chain-id okchain \
    -y -c ${CONCURRENT_NUM} \
    -x ${NUM_PER_THREAD} --node c22:26657 -b block

    okecho okchaincli tx send ${CAPTAINADDR} ${QUANTITY}okb \
    --from ${USER} \
    --home ${OKDEXCLI_HOME} \
    --chain-id okchain \
    -y -c ${CONCURRENT_NUM} \
    -x ${NUM_PER_THREAD} --node c23:26657 -b block

    okecho okchaincli tx send ${CAPTAINADDR} ${QUANTITY}okb \
    --from ${USER} \
    --home ${OKDEXCLI_HOME} \
    --chain-id okchain \
    -y -c ${CONCURRENT_NUM} \
    -x ${NUM_PER_THREAD} --node c24:26657 -b block
}


main() {


    for((;;)) do

        round

#        ./reward.sh
    done
}

main


