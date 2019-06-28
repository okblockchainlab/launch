#!/bin/bash

CURDIR=`dirname $0`



main() {

    h=qa88 ${CURDIR}/callqa.sh tail -f /root/.okchaind/okchaind.log |grep BlockHeight
}

main


