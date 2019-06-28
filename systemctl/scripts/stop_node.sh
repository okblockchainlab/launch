#!/bin/bash

. $HOME/okchain/launch/systemctl/scripts/okchaind.profile

${OKCHAIN_CLI} query debug stop
sleep 2
ps -ef|grep okchaind|grep -v grep |awk '{print "kill -9 "$2}' | sh