#!/bin/bash


for ((index=0; index<3; index++)) do
    echo "seed $index"
    okchaind tendermint show-node-id --home nodekey/seed${index}
    okchaind tendermint show-validator --home nodekey/seed${index}
done

for ((index=0; index<$1; index++)) do
    okchaind tendermint show-node-id --home nodekey/node${index}
    okchaind tendermint show-validator --home nodekey/node${index}
done



