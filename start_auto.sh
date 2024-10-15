#!/bin/bash

# 调用start.sh
bash start.sh

# 检查 Clash 服务是否已启动
echo "等待 Clash 服务启动..."

# 循环检测 Clash 服务是否启动
while true; do
    CLASH_PID_NUM=$(ps -ef | grep [c]lash-linux-a | wc -l)
    
    if [ $CLASH_PID_NUM -gt 0 ]; then
        echo "Clash 服务已启动，PID: $(ps -ef | grep [c]lash-linux-a | awk '{print $2}')"
        sleep 0.2
        break
    else
        echo "Clash 服务尚未启动，等待1秒后再检查..."
        sleep 1
    fi
done

echo -e "\n*******自动执行上述命令*******\n"

# 自动执行加载环境变量操作
echo -e "自动执行以下命令加载环境变量: source /etc/profile.d/clash.sh"
source /etc/profile.d/clash.sh
echo -e "\n"

# 自动开启代理
echo -e "自动执行以下命令开启系统代理: proxy_on"
proxy_on
echo -e "若要临时关闭系统代理，请执行: proxy_off\n"

# 加载.env变量文件
export CLASH_SERVER_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
source $CLASH_SERVER_DIR/.env

# 确保端口变量已经正确加载
Http_Port=${CLASH_HTTP_PORT:-7890}               # 默认 HTTP 代理端口 7890
Socks_Port=${CLASH_SOCKS_PORT:-7891}             # 默认 SOCKS5 代理端口 7891
Redir_Port=${CLASH_REDIR_PORT:-7892}             # 默认 redir 代理端口 7892
Controller_Port=${CLASH_CONTROLLER_PORT:-9090}   # 默认控制端口 9090

echo -e "\n"
echo -e "自动检查服务端口"
netstat -tln | grep -E "${Controller_Port}|${Http_Port}|${Socks_Port}|${Redir_Port}"

echo -e "\n"

echo -e "自动检查环境变量"
env | grep -E 'http_proxy|https_proxy'
echo -e "\n"

# 清理所有环境变量
unset CLASH_PID_NUM
unset CLASH_SERVER_DIR
unset CLASH_URL
unset CLASH_SECRET

unset CLASH_HTTP_PORT
unset CLASH_SOCKS_PORT
unset CLASH_REDIR_PORT
unset CLASH_CONTROLLER_PORT

unset Http_Port
unset Socks_Port
unset Redir_Port
unset Controller_Port

echo -e "自动开启 Clash 完成！\n"