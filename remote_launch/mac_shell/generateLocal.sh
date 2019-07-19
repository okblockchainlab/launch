#!/bin bash
PATH=$PATH:/usr/local/go/bin

testpath="/root/testnet"

rm -rf ${testpath}

gaiad version

echo "====================== generate testnet with 4 nodes ======================"
gaiad testnet --v 4 --output-dir ${testpath} --chain-id testchain --starting-ip-address 192.168.13.121<<EOF
12345678
12345678
12345678
12345678
EOF


OS=`uname`
for i in $(seq 0 3);
do
    if [ "Linux" = ${OS} ]; then
       sed -i "s/addr_book_strict = true/addr_book_strict = false/g" /root/testnet/node${i}/gaiad/config/config.toml
    else
       sed -i '' "s/addr_book_strict = true/addr_book_strict = false/g" /root/testnet/node${i}/gaiad/config/config.toml
   fi
done

echo "====================== distribute ./node0/ to okchain21:/root/gaianode======================"
mv ${testpath}/node0/ /root/gaianode

#for (( i = 0; i < ${5}; ++i )); do
#    k=` grep  -n "persistent_peers" node${1}/gaiad/config/config.toml  | cut  -d  ":"  -f  1`
#    sed -i
#done
