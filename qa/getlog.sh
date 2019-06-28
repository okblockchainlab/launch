#!/bin/bash

#QA_HOST=(qa78 qa72 qa88 qa91 qa92 qa68 qa45)
QA_HOST=(qa78 qa72 qa88 qa91 qa92)


get_tar() {
    h=$1 ./callqa.sh /usr/bin/tar -zcvf $1.okchaind.log.tar.gz /root/.okchaind/okchaind.log
    scp root@$1:/root/$1.okchaind.log.tar.gz .
}

untar() {
    `which tar` -zxvf $1.okchaind.log.tar.gz
    mv $1.okchaind.log.tar.gz ./root
    mv ./root/.okchaind/okchaind.log $1.okchaind.log
}

main() {
      for host in ${QA_HOST[@]}
      do
          get_tar $host
          untar $host
      done
}

main