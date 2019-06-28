#!/bin/bash


TOKENS=(btc eth eos ltc xrp xmr bts atom bch dash xxb)

TOKEN_FILE=tmp.token.json

main() {

    rm ${TOKEN_FILE}
    rm token_suffix.profile

    index=0
    for token in ${TOKENS[@]}
    do
        okchaincli tx token issue --mintable --symbol $token -n 666 \
            --from captain -y |grep value|grep -|awk '{print $2}' >> ${TOKEN_FILE}
        ((index++))
    done

    res=""
    index=0
    cat ${TOKEN_FILE} | while read line
    do
        tmp=${line//\"/}
        output="${output}${tmp} "
        echo "$output"
cat>token_suffix.profile<<EOF
TOKENS=(${output})
EOF
    done

    rm ${TOKEN_FILE}
}

main

