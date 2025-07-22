#!/bin/bash
# 调试版本 - 查看ps命令的实际输出

echo "=== Debug PocketBase Monitor ==="

# 获取容器ID和进程PID
CONTAINER_ID=$(docker ps | grep pocketbase | head -1 | awk '{print $1}')
POCKETBASE_PID=$(docker exec $CONTAINER_ID pgrep -f "pocketbase" | head -1)

echo "Container: $CONTAINER_ID"
echo "PocketBase PID: $POCKETBASE_PID"
echo ""

echo "=== Debugging ps command output ==="

echo "1. Raw ps output with headers:"
docker exec $CONTAINER_ID ps -o pid,rss,vsz,pcpu,pmem -p $POCKETBASE_PID

echo ""
echo "2. Raw ps output without headers:"
docker exec $CONTAINER_ID ps -o pid,rss,vsz,pcpu,pmem -p $POCKETBASE_PID --no-headers

echo ""
echo "3. Alternative ps format:"
docker exec $CONTAINER_ID ps -o rss,vsz,pcpu,pmem -p $POCKETBASE_PID --no-headers

echo ""
echo "4. Using /proc filesystem:"
docker exec $CONTAINER_ID cat /proc/$POCKETBASE_PID/status | grep -E "VmRSS|VmSize"

echo ""
echo "5. Using top command:"
docker exec $CONTAINER_ID top -bn1 -p $POCKETBASE_PID

echo ""
echo "6. Docker stats:"
docker stats --no-stream $CONTAINER_ID
