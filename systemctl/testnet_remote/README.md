
## 1. 测试网络部署

1. 执行```./git.sh```仅更新launch脚本
1. 执行```./git.sh -b```更新launch脚本，并编译并上传最新的binaries到git, 再从git下载最新binaries
1. 执行```./start.sh -r``` 不清空区块数据启动系统
1. 执行```./start.sh -r -c``` 清空所有区块数据，再启动系统
1. 启动系统后，再执行```./start.sh -t``` 发币上币

## 2. ```start.sh``` usage
```sh
./start.sh
```
`-c` 清理所有区块数据后，重新创建创世块启动节点

`-r` restart所有机器上的okchaind

`-s` 停止所有机器上的okchaind

`-t` 发币、上币提案以及提案投票，激活

`-o` 用captain账户挂单测试

```sh
./git.sh
```
更新远程机器launch代码库
`-c` git clone

