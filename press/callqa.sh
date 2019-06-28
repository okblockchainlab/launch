#!/bin/bash


SSH="ssh root"

call() {
${SSH}@${h} << eeooff
    source /home/ubuntu/.env.sh
    $@
    exit
eeooff
}

call $@