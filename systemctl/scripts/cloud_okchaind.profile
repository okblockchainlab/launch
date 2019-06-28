CURDIR=`dirname $0`
. ${CURDIR}/base.profile


# 是否使用内网IP 
# 如果false，则使用公网IP，OKCHAIN_TESTNET_FULL_HOSTS设置其他节点公网IP
# 如果是true，则必须设置IP_PREFIX，OKCHAIN_TESTNET_FULL_HOSTS设置其他节点内网IP
IP_INNET=false
IP_PREFIX=172.31
HOSTS_PREFIX=okchain_cloud
SCP_TAG="-i ~/okchain-dex-test.pem ubuntu"
USER=ubuntu

# OKCHAIN_TESTNET_SEED_NODES=("172.31.34.156")
# OKCHAIN_TESTNET_VAL_NODES=("172.31.47.97" "172.31.46.79" "172.31.42.153" "172.31.32.196")
# OKCHAIN_TESTNET_FULL_NODES=("172.31.34.176" "172.31.38.192")
OKCHAIN_TESTNET_SEED_NODES=("ec2-18-179-197-204.ap-northeast-1.compute.amazonaws.com")
OKCHAIN_TESTNET_VAL_NODES=("ec2-13-231-244-223.ap-northeast-1.compute.amazonaws.com" "ec2-13-115-204-32.ap-northeast-1.compute.amazonaws.com" "ec2-3-112-248-208.ap-northeast-1.compute.amazonaws.com" "ec2-52-195-8-148.ap-northeast-1.compute.amazonaws.com")
OKCHAIN_TESTNET_FULL_NODES=("ec2-52-193-52-106.ap-northeast-1.compute.amazonaws.com" "ec2-13-231-34-83.ap-northeast-1.compute.amazonaws.com")
