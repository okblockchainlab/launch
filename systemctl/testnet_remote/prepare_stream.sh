#!/bin/bash

. ./env.profile
PROFILE=${ENV_TYPE}_okchaind.profile
. ./${PROFILE}

function init_pulsar {
    echo "init pulsar"
${SSH}@okchain_cloud13 << EOF
    ${OKCHAIN_LAUNCH_TOP}/systemctl/scripts/pulsardocker.sh
EOF
    echo "init pulsar done"
}

function init_redis {
    echo "init redis"
${SSH}@okchain_cloud16 << EOF
    echo "flushall" | redis-cli --pipe
EOF
    echo "init redis done"
}

function init_mysql {
    echo "init mysql"
${SSH}@okchain_cloud25 << EOF
    mysql -u root -pokchain -e "drop database okdex;create database okdex;grant all on okdex.* to okdexer@'172.%' identified by 'okdex123\!';"
    mysql -u root -pokchain -e "grant all on okdex.* to okdexer@'localhost' identified by 'okdex123\!';grant all on okdex.* to okdexer@'127.0.0.1' identified by 'okdex123\!';"
EOF
    echo "init mysql done"
}

function main {
    init_pulsar
    init_redis
    init_mysql
}

main