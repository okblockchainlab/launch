#!/bin bash

rm -rf $HOME/testnet

gaiad version

gaiad testnet --v 4 --output-dir $HOME/testnet --chain-id testchain --starting-ip-address 192.168.13.121<<EOF
12345678
12345678
12345678
12345678
EOF


OS=`uname`
for i in $(seq 0 4);
do
    if [ "Linux" = ${OS} ]; then
       sed -i "s/addr_book_strict = true/addr_book_strict = false/g" $HOME/testnet/node${i}/gaiad/config/config.toml
    else
       sed -i '' "s/addr_book_strict = true/addr_book_strict = false/g" $HOME/testnet/node${i}/gaiad/config/config.toml
   fi
done

scp -r $HOME/testnet/node1/ root@okchain22:/root/gaianode1
scp -r $HOME/testnet/node2/ root@okchain23:/root/gaianode2
scp -r $HOME/testnet/node3/ root@okchain24:/root/gaianode3

#for (( i = 0; i < ${5}; ++i )); do
#    k=` grep  -n "persistent_peers" node${1}/gaiad/config/config.toml  | cut  -d  ":"  -f  1`
#    sed -i
#done
