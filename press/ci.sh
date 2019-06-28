#!/usr/bin/env bash

COMMENTS=upd

if [ $# -lt 0 ]; then
    COMMENTS=$1
fi

git commit -m $COMMENTS
git push

