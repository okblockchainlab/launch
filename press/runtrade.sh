#!/bin/bash

CURDIR=`dirname $0`

. ${CURDIR}/../systemctl/testnet_remote/token.profile

#TOKENS=(dash)

while getopts "t" opt; do
  case $opt in
    t)
      echo "TEST TRANSFER"
      TRANSFER="Y"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

okecho() {
    echo "shell exec: [$@]"
    $@
}

trade() {

    admin_index=$1
    token=$2
    reward=$3

    # 1000000 per user
    if [ "$reward" == "reward" ]; then
        okecho ${CURDIR}/rewardby_admin.sh -N -i ${admin_index} -n c22 -c 16 -b 100000 -h ${CURDIR}/products/${token}_okb/${token}_okb
    fi

    if [ ! -z "${TRANSFER}" ]; then
        ./transfer.sh -q 0.05 -c 10 -x 10 -h ./products/${token}_okb/${token}_okb 2>&1 >products/${token}_okb.json &
    else
        ${CURDIR}/dex.sh -P ${token}_okb 2>&1 >products/${token}_okb.json &
    fi
}


main() {

    ${CURDIR}/stop.sh

    sleep 1

    index=0
    for token in ${TOKENS[@]}
    do
        trade $index ${token} $1
        ((index++))
    done
}

if [ ! -z "${TRANSFER}" ]; then
    main $2
else
    main $1
fi
