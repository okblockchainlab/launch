#!/bin/bash


SSH="ssh root"

call() {
${SSH}@${h} << eeooff
    $@
    exit
eeooff
}

call $@