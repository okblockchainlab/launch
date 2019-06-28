#!/bin/bash

CURDIR=`dirname $0`


./prerun.sh

./runtrade.sh reward 2>&1 > a.json &

