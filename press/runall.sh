#!/bin/bash

CURDIR=`dirname $0`

while getopts "t" opt; do
  case $opt in
    t)
      echo "TRANSFER=Y"
      TRANSFER="Y"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

./prerun.sh

if [ ! -z "${TRANSFER}" ]; then
    ./runtrade.sh -t reward 2>&1 > a.json &
else
    ./runtrade.sh reward 2>&1 > a.json &
fi

