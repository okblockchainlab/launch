#!/usr/bin/env bash

okecho() {
    echo "shell exec: [$@]"
    $@
}

# generate accounts and transfer coins
okecho ./staking_gen_accounts.sh -N -n c25 -b 2000 -c $1 -u admin

# get validators
okecho ./staking_get_validators.sh -n c25

# bonding
okecho ./staking_bonding.sh -n c25 -u admin -b 10 -c $1

# unbonding
okecho ./staking_unbonding.sh -n c25 -u admin -U 5 -c $1

# bonding again
okecho ./staking_bonding.sh -n c25 -u admin -b 5 -c $1

# rebonding
okecho ./staking_rebonding.sh -n c25 -u admin -r 5 -c $1

# clean tmp file
okecho rm -f /tmp/oper_validators