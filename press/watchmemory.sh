#!/usr/bin/env bash

SAMPLING=30

PID=`ps -ef|grep okchaind|grep -v grep|grep -v tail| awk '{print $2}'`

echo $PID
if [ $# -gt 0 ]; then
    SAMPLING=$1
fi

echo "Start..."

index=0
for((;;))
do
    sdate=`date +"%Y-%m-%d %H:%M:%S"`
    smem=`ps -e -o pid -o comm -o pcpu -o rss -o vsz | grep $PID | grep okchaind`

    ((index++))
    echo $index "$PID: date=["$sdate"], mem_info["$smem"]" >> ~/memoryhistory.txt
    echo $index "$PID: date=["$sdate"], mem_info["$smem"]"
    sleep ${SAMPLING}
done