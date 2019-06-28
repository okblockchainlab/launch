#!/bin/bash



main() {

    h=qa88 ./callqa.sh tail -f /root/.okchaind/okchaind.log |grep BlockHeight
}

main


