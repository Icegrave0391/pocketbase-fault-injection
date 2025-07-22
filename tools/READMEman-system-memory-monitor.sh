#!/bin/bash
# 系统级内存监控工具

echo "=== 系统级内存监控工具 ==="

# 1. top/htop 监控
echo "1. 使用 top 监控 PocketBase 进程："
echo "docker exec -it <container_id> top -p \$(pgrep pocketbase)"

# 2. 使用 ps 查看内存
echo ""
echo "2. 使用 ps 查看内存使用："
echo "docker exec <container_id> ps -o pid,ppid,cmd,%mem,%cpu --sort=-%mem"

# 3. 使用 free 查看系统内存
echo ""
echo "3. 查看容器内系统内存："
echo "docker exec <container_id> free -h"

# 4. 使用 smem (如果安装了)
echo ""
echo "4. 使用 smem 详细内存分析："
echo "docker exec <container_id> smem -t -k"

# 5. 内存映射信息
echo ""
echo "5. 查看进程内存映射："
echo "docker exec <container_id> cat /proc/\$(pgrep pocketbase)/smaps"

# 6. 实时监控脚本
echo ""
echo "6. 实时监控脚本示例："
cat << 'EOF'
#!/bin/bash
# 实时监控 PocketBase 内存使用
while true; do
    CONTAINER_ID=$(docker ps | grep pocketbase | awk '{print $1}')
    if [ ! -z "$CONTAINER_ID" ]; then
        echo "$(date): $(docker exec $CONTAINER_ID ps aux | grep pocketbase | grep -v grep | awk '{print $6}') KB"
    fi
    sleep 10
done
EOF
