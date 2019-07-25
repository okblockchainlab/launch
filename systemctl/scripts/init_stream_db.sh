#!/usr/bin/env bash

while getopts "mrpe" opt; do
  case $opt in
    m)
      echo "RESTART MYSQL"
      MYSQL="true"
      ;;
    r)
      echo "RESTART REDIS"
      REDIS="true"
      ;;
    p)
      echo "RESTART PULSAR"
      PULSAR="true"
      ;;
    e)
      echo "RESTART ETCD"
      ETCD="true"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

restart_redis() {
    echo "===== restart redis ...... ====="
    # stop & remove redis container
    docker kill `docker ps | grep test_redis | awk '{print $1}'`
    docker rm `docker ps -a | grep test_redis | awk '{print $1}'`

    # start redis
    docker run -p 16379:6379 --name test_redis -d redis:3.2
    echo "===== restart redis successfully ====="
}

restart_mysql() {
    echo "===== restart mysql ...... ====="
    # stop & remove mysql container
    docker kill `docker ps | grep test_mysql | awk '{print $1}'`
    docker rm `docker ps -a | grep test_mysql | awk '{print $1}'`

    # start mysql
    docker run -e MYSQL_ROOT_PASSWORD=root -p 13306:3306 --name test_mysql -d mysql:5.6
    docker exec test_mysql bash -c "echo -e '[mysqld]\nskip-grant-tables' > /etc/mysql/conf.d/my.cnf"
    docker restart test_mysql
    sleep 2
    docker exec test_mysql mysql -h localhost --user root -e "use mysql;\nupdate user set password=PASSWORD('123456') where user='root';"
    docker exec test_mysql rm -f /etc/mysql/conf.d/my.cnf
    docker restart test_mysql
    sleep 2
    docker exec test_mysql mysql --user root --password=123456 -e "create database okdex;"
    docker exec test_mysql mysql --user root --password=123456 -e "grant all on okdex.* to okdexer@'172.%' identified by 'okdex123!';"
    docker exec test_mysql mysql --user root --password=123456 -e "grant all on okdex.* to okdexer@'localhost' identified by 'okdex123!';"
    docker exec test_mysql mysql --user root --password=123456 -e "grant all on okdex.* to okdexer@'127.0.0.1' identified by 'okdex123!';"
    echo "===== restart mysql successfully ====="
}

restart_pulsar() {
    echo "===== restart pulsar ...... ====="
    # remove pulsar container
    docker kill `docker ps | grep test_pulsar | awk '{print $1}'`
    docker rm `docker ps -a | grep test_pulsar | awk '{print $1}'`

    docker run --name test_pulsar -p 8080:8080 -p 6650:6650 -d apachepulsar/pulsar-standalone:2.3.1 bin/pulsar standalone
    sleep 25
    docker exec test_pulsar ./bin/pulsar-admin tenants create market_quotation
    docker exec test_pulsar ./bin/pulsar-admin namespaces create market_quotation/dex_matcher
    docker exec test_pulsar ./bin/pulsar-admin topics create-partitioned-topic persistent://market_quotation/dex_matcher/dex_spot_standard --partitions 2

    docker exec test_pulsar ./bin/pulsar-admin tenants create push_okdex
    docker exec test_pulsar ./bin/pulsar-admin namespaces create push_okdex/push_v3
    docker exec test_pulsar ./bin/pulsar-admin topics create-partitioned-topic persistent://push_okdex/push_v3/public --partitions 4
    #docker exec test_pulsar ./bin/pulsar-admin non-persistent create-partitioned-topic non-persistent://push_okex/push_v3/public --partitions 4

    echo "===== restart pulsar successfully ====="
}

restart_etcd() {
    echo "===== restart etcd ...... ====="
    # remove pulsar container
    docker kill `docker ps | grep test_etcd | awk '{print $1}'`
    docker rm `docker ps -a | grep test_etcd | awk '{print $1}'`
    rm -rf /tmp/etcd-data.tmp && mkdir -p /tmp/etcd-data.tmp
    nohup docker run \
      -p 2379:2379 \
      -p 2380:2380 \
      --mount type=bind,source=/tmp/etcd-data.tmp,destination=/etcd-data \
      --name test_etcd \
      quay.io/coreos/etcd:v3.3.13 \
      /usr/local/bin/etcd \
      --name s1 \
      --data-dir /etcd-data \
      --listen-client-urls http://0.0.0.0:2379 \
      --advertise-client-urls http://0.0.0.0:2379 \
      --listen-peer-urls http://0.0.0.0:2380 \
      --initial-advertise-peer-urls http://0.0.0.0:2380 \
      --initial-cluster s1=http://0.0.0.0:2380 \
      --initial-cluster-token tkn \
      --initial-cluster-state new > /dev/null 2>&1 &
      sleep 10
    echo "===== restart etcd successfully ====="
}

main() {
    if [ ! -z "${MYSQL}" ];then
        restart_mysql
    fi

    if [ ! -z "${REDIS}" ];then
        restart_redis
    fi

    if [ ! -z "${PULSAR}" ];then
        restart_pulsar
    fi

    if [ ! -z "${ETCD}" ];then
        restart_etcd
    fi

}

main

