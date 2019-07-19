#!/usr/bin/env bash
# run in ubuntu with root

pid=`ps -ef|grep gaiad|grep -v grep | awk '{print $2}'`
echo "kill gaiad ,pid: $pid"
kill ${pid}