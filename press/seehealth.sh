#!/bin/bash



taillog() {
    echo "-----------------------${1}---------------------"
    h=$1 ./callcloud.sh tail -n 100  /home/ubuntu/.okchaind/okchaind.log
}


taillog c16
taillog c21
taillog c22
taillog c23
taillog c24
taillog c25

