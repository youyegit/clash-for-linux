echo -e "\n自动执行以下命令关闭系统代理：proxy_off\n"
source /etc/profile.d/clash.sh
proxy_off
echo -e "\n"

# 调用shutdown.sh
bash shutdown.sh

# 检查 Clash 服务是否已成功关闭
CLASH_PID_NUM=$(ps -ef | grep [c]lash-linux-a | wc -l)

# 循环检查是否还存在 Clash 进程，直到其完全关闭
while [ $CLASH_PID_NUM -ne 0 ]; do
    echo "等待 Clash 服务关闭..."
    sleep 1  # 每隔1秒检查一次
    CLASH_PID_NUM=$(ps -ef | grep [c]lash-linux-a | wc -l)
done

echo -e "\n*******上述命令已预先执行*******\n"

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
echo -e "此处应该没有其他输出！\n"

echo -e "自动检查环境变量"
env | grep -E 'http_proxy|https_proxy'
echo -e "此处应该没有其他输出！\n"

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

echo -e "自动关闭 Clash 完成！\n"