#!/bin/bash

CURDIR=`dirname $0`


# 16 concurrent/admins, each 1,000,000*16 coins
./reward.sh -R -n c22 -b 20000000 -c 16 -u admin -h admin_home/admin -m
