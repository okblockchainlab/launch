#!/bin/bash

CURDIR=`dirname $0`

CONCURRENT_NUM=50
ROUND_NUM=100000
HOST=c21:26657

while getopts "c:n:u:" opt; do
  case $opt in
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

for ((;;)) do
    tiger send -n $ROUND_NUM -c $CONCURRENT_NUM \
        -u $HOST >> tiger.log
done