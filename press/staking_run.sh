#!/usr/bin/env bash

okecho() {
    echo "shell exec: [$@]"
    $@
}

# generate accounts and transfer coins
okecho ./staking_gen_accounts.sh -N -n c25 -b 2000 -c 2 -u admin

# create validators
#./staking_cre_validators.sh -N 21 -n c25 -u admin -s 100 -c 500 -h admin_home/admin

# get validators
okecho ./staking_get_validators.sh -n c25

# bonding
okecho ./staking_bonding.sh -n c25 -u admin -b 10 -c 2

# unbonding
okecho ./staking_unbonding.sh -n c25 -u admin -U 5 -c 2

# bonding again
okecho ./staking_bonding.sh -n c25 -u admin -b 5 -c 2

# rebonding
okecho ./staking_rebonding.sh -n c25 -u admin -r 5 -c 2

# clean tmp file
okecho rm -f /tmp/oper_validators