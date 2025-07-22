#!/bin/bash
# Docker 容器内存监控脚本

echo "=== Docker 容器内存监控工具 ==="

# 获取 PocketBase 容器ID
CONTAINER_ID=$(docker ps | grep pocketbase | awk '{print $1}')

if [ -z "$CONTAINER_ID" ]; then
    echo "未找到运行中的 PocketBase 容器"
    exit 1
fi

echo "监控容器: $CONTAINER_ID"

# 1. docker stats - 实时监控
echo ""
echo "1. 使用 docker stats 实时监控："
echo "docker stats $CONTAINER_ID"

# 2. 详细内存信息
echo ""
echo "2. 详细内存信息："
docker exec $CONTAINER_ID cat /proc/meminfo | head -10

# 3. 进程内存使用
echo ""
echo "3. PocketBase 进程内存使用："
docker exec $CONTAINER_ID ps aux | grep pocketbase

# 4. 连续监控脚本
echo ""
echo "4. 连续监控内存变化 (每5秒)："
echo "while true; do docker stats --no-stream $CONTAINER_ID; sleep 5; done"

# 5. 导出内存统计到文件
echo ""
echo "5. 导出内存统计到文件："
echo "docker stats --no-stream --format 'table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}' $CONTAINER_ID > memory_stats.log"
