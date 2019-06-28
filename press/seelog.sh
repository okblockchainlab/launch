#!/bin/bash



main() {

    h=c22 ./callcloud.sh tail -f log |grep BlockHeight
}

main


