#!/bin/bash

CURDIR=`dirname $0`

CONCURRENT_NUM=50
ROUND_NUM=100000
while getopts "c:n:" opt; do
  case $opt in
    n)
      echo "ROUND_NUM=$OPTARG"
      ROUND_NUM=$OPTARG
      ;;
    c)
      echo "CONCURRENT_NUM=$OPTARG"
      CONCURRENT_NUM=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

for ((;;)) do
    tiger send -n $ROUND_NUM -c $CONCURRENT_NUM \
        -u c21:26657,c22:26657,c23:26657,c24:26657,c16:26657,c25:26657,c13:26657 >> tiger.log
done