#!/bin/bash


function main {
    git reset --hard HEAD~1
    git add okchainbins.tar.gz
    git commit -m "update okchainbins"
    git push -f
}

main