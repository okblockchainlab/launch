#!/usr/bin/env bash

rm -rf ../../testnet

gaiad version

gaiad testnet --v 5 --output-dir ../../testnet --chain-id testchain --starting-ip-address 192.168.13.121<<EOF
12345678
12345678
12345678
12345678
12345678
EOF

cd ../../testnet

#for (( i = 0; i < ${5}; ++i )); do
#    k=` grep  -n "persistent_peers" node${1}/gaiad/config/config.toml  | cut  -d  ":"  -f  1`
#    sed -i
#done

OS=`uname`
for (( i = 0; i < 5; ++i )); do
    if [[ ! "Darwin" = "${OS}" ]]; then
        sed -i "s/2665/1665/g" node${i}/gaiad/config/config.toml
        sed -i "s/2665/1665/g" node${i}/gaiad/config/genesis.json
    else
        sed -i '' "s/2665/1665/g" node${i}/gaiad/config/config.toml
        sed -i '' "s/2665/1665/g" node${i}/gaiad/config/genesis.json
    fi
done