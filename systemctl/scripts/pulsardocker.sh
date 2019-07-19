#!/bin/bash

docker stop `docker ps -a  | grep pulsar | awk '{print $1}'`
docker rm `docker ps -a  | grep pulsar | awk '{print $1}'`
docker run --name test_pulsar -p 8080:8080 -p 6650:6650 -d apachepulsar/pulsar-standalone:2.3.1 bin/pulsar standalone
sleep 20
docker exec -i test_pulsar ./bin/pulsar-admin tenants create market_quotation
docker exec -i test_pulsar ./bin/pulsar-admin namespaces create market_quotation/dex_matcher
docker exec -i test_pulsar ./bin/pulsar-admin topics create-partitioned-topic persistent://market_quotation/dex_matcher/dex_spot_standard --partitions 2
docker exec -i test_pulsar ./bin/pulsar-admin topics partitioned-stats persistent://market_quotation/dex_matcher/dex_spot_standard --per-partition

docker exec -i test_pulsar ./bin/pulsar-admin tenants create push_okdex
docker exec -i test_pulsar ./bin/pulsar-admin namespaces create push_okdex/push_v3
docker exec -i test_pulsar ./bin/pulsar-admin topics create-partitioned-topic persistent://push_okdex/push_v3/public --partitions 4
docker exec -i test_pulsar ./bin/pulsar-admin topics partitioned-stats persistent://push_okdex/push_v3/public --per-partition

echo "===== start pulsar successfully ====="


