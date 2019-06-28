#!/bin/bash


function main {
    git update-ref -d HEAD
    git add okchainbins.tar.gz
    git commit -m "update okchainbins"
    git push -f
}

main