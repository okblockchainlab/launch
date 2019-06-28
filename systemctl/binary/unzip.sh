#!/bin/bash


function main {
    echo "untar okchainbins.tar.gz..."
    tar -zxvf okchainbins.tar.gz -C ..
    tar -zxvf launchbins.tar.gz -C ..
}

main