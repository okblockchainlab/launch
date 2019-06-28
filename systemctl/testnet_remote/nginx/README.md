# nginx 配置说明

1. 安装nginx
2. 添加Nginx配置文件`okchain.config`，使之生效
3. 其中：
    * `192.168.80.168:1317`为okchain rest-server地址，由`okchaincli rest-server`启动
    * `http://192.168.80.192`Origin地址，为前端服务地址
    * `7777`为该nginx服务的监听端口