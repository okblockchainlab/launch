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
OKCHAIN_TESTNET_SEED_NODES=("ec2-3-112-197-173.ap-northeast-1.compute.amazonaws.com")
OKCHAIN_TESTNET_VAL_NODES=("ec2-18-179-4-209.ap-northeast-1.compute.amazonaws.com" "ec2-54-95-169-118.ap-northeast-1.compute.amazonaws.com" "ec2-54-65-208-55.ap-northeast-1.compute.amazonaws.com" "ec2-54-199-163-29.ap-northeast-1.compute.amazonaws.com")
OKCHAIN_TESTNET_FULL_NODES=("ec2-52-197-220-161.ap-northeast-1.compute.amazonaws.com" "ec2-13-115-112-74.ap-northeast-1.compute.amazonaws.com")
