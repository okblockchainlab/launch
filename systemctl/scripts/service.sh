#!/bin/bash


main() {

    ENV_TYPE=$1
    cp ${ENV_TYPE}_okchaind.profile okchaind.profile

    sudo cp okchaind.service /etc/systemd/system/okchaind.service
    sudo systemctl daemon-reload
}


main $1