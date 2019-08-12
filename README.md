Fork from https://github.com/cosmos/launch

# 预先工作
* 1.在工作机器上执行mac_shell下的 `./syncNewCosmosVersion.sh -v 0.xx.y` , 该脚本下载指定版本cosmos-sdk到本地，
* 2.执行`go mod vendor` 下载依赖 (由于okchain21-24开启安全访问策略，无法正常下载依赖，所以只能采用该方案)
* 3.再登陆到其中okchain的一台机器执行 `./installGaia.sh -v 0.xx.y` ，该脚本在linux机器上编译gaia，并上传到gitlab的cosmosbins仓库中
* 
* 注：syncNewGaiaVersion.sh 和 installGaiaNew.sh 用于之后gaia版本编译 (gaia从v0.35.0开始独立放置到一个仓库)

# start.sh 
* `-v v0.xx.y` 必须指定特定版本,如 v0.34.5 v0.34.7, 默认v0.35.0
* `-u`         更新launch脚本到okchain21-24
* `-g`         下载gaiad,gaiacli到okchain21-24
* `-f`         使用gaiad testnet生成配置文件，并分配到okchain21-24 （执行完成后，检查每台机器目录/root/gaianode/下是否都存在gaiad/ gaiacli/)
* `-s`         在okchain21-24启动gaiad （优化中）
* `-k`         在okchain21-24关闭gaiad

# 其他
* 先前尝试通过gaiad init 生成配置，但是之后创建validator并启动seed节点，其他节点无法正常通信，之后改用testnet方式生成配置文件（仍在解决中）
* 目前okchain21 必须使用26656，26657端口，okchain22-24可使用如16656，16657端口
* 当前方式已能正常出块并稳定
