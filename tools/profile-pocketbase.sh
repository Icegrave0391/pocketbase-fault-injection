#!/bin/bash
# 外部profiling脚本 - 监控Docker内的PocketBase进程

echo "=== PocketBase Docker Profiling Tool ==="

# 获取容器ID
CONTAINER_ID=$(docker ps | grep pocketbase | head -1 | awk '{print $1}')

if [ -z "$CONTAINER_ID" ]; then
    echo "Error: No running PocketBase container found"
    echo "Please start the container first with ./run-dev.sh"
    exit 1
fi

echo "Found container: $CONTAINER_ID"

# 获取PocketBase进程PID
POCKETBASE_PID=$(docker exec $CONTAINER_ID pgrep -f "pocketbase serve" | head -1)

if [ -z "$POCKETBASE_PID" ]; then
    echo "Error: PocketBase process not found in container"
    echo "Please start PocketBase first with ./pocketbase-serve.sh"
    exit 1
fi

echo "Found PocketBase PID: $POCKETBASE_PID"
echo ""

# 创建profiling目录
mkdir -p profiling/$(date +%Y%m%d_%H%M%S)
cd profiling/$(date +%Y%m%d_%H%M%S)

echo "=== Available Profiling Options ==="
echo "1. CPU Profile (30 seconds)"
echo "2. Memory Heap Profile" 
echo "3. Goroutine Profile"
echo "4. Memory Allocation Profile"
echo "5. Block Profile"
echo "6. Continuous Memory Monitoring"
echo "7. All profiles"
echo ""

read -p "Select option (1-7): " option

case $option in
    1)
        echo "Starting CPU profiling for 30 seconds..."
        docker exec $CONTAINER_ID timeout 30s go tool pprof -raw -output=/tmp/cpu.prof -seconds=30 -pid=$POCKETBASE_PID
        docker cp $CONTAINER_ID:/tmp/cpu.prof ./cpu.prof
        echo "CPU profile saved to: cpu.prof"
        echo "Analyze with: go tool pprof cpu.prof"
        ;;
        
    2)
        echo "Collecting memory heap profile..."
        docker exec $CONTAINER_ID go tool pprof -raw -output=/tmp/heap.prof -pid=$POCKETBASE_PID
        docker cp $CONTAINER_ID:/tmp/heap.prof ./heap.prof
        echo "Heap profile saved to: heap.prof"
        echo "Analyze with: go tool pprof heap.prof"
        ;;
        
    3)
        echo "Collecting goroutine profile..."
        docker exec $CONTAINER_ID go tool pprof -raw -output=/tmp/goroutine.prof -goroutines -pid=$POCKETBASE_PID
        docker cp $CONTAINER_ID:/tmp/goroutine.prof ./goroutine.prof
        echo "Goroutine profile saved to: goroutine.prof"
        echo "Analyze with: go tool pprof goroutine.prof"
        ;;
        
    4)
        echo "Collecting memory allocation profile..."
        docker exec $CONTAINER_ID go tool pprof -raw -output=/tmp/allocs.prof -alloc_objects -pid=$POCKETBASE_PID
        docker cp $CONTAINER_ID:/tmp/allocs.prof ./allocs.prof
        echo "Allocation profile saved to: allocs.prof"
        echo "Analyze with: go tool pprof allocs.prof"
        ;;
        
    5)
        echo "Collecting block profile..."
        docker exec $CONTAINER_ID go tool pprof -raw -output=/tmp/block.prof -block -pid=$POCKETBASE_PID
        docker cp $CONTAINER_ID:/tmp/block.prof ./block.prof
        echo "Block profile saved to: block.prof"
        echo "Analyze with: go tool pprof block.prof"
        ;;
        
    6)
        echo "Starting continuous memory monitoring (Ctrl+C to stop)..."
        echo "Timestamp,RSS(KB),VSize(KB),CPU%" > memory_monitor.csv
        
        while true; do
            timestamp=$(date '+%Y-%m-%d %H:%M:%S')
            mem_info=$(docker exec $CONTAINER_ID ps -o pid,rss,vsz,pcpu -p $POCKETBASE_PID | tail -1)
            rss=$(echo $mem_info | awk '{print $2}')
            vsz=$(echo $mem_info | awk '{print $3}')
            cpu=$(echo $mem_info | awk '{print $4}')
            
            echo "$timestamp,$rss,$vsz,$cpu" | tee -a memory_monitor.csv
            sleep 5
        done
        ;;
        
    7)
        echo "Collecting all profiles..."
        
        # CPU profile
        echo "1/5 CPU profiling (30s)..."
        docker exec $CONTAINER_ID timeout 30s go tool pprof -raw -output=/tmp/cpu.prof -seconds=30 -pid=$POCKETBASE_PID &
        
        # Heap profile
        echo "2/5 Heap profiling..."
        docker exec $CONTAINER_ID go tool pprof -raw -output=/tmp/heap.prof -pid=$POCKETBASE_PID
        
        # Goroutine profile
        echo "3/5 Goroutine profiling..."
        docker exec $CONTAINER_ID go tool pprof -raw -output=/tmp/goroutine.prof -goroutines -pid=$POCKETBASE_PID
        
        # Allocation profile
        echo "4/5 Allocation profiling..."
        docker exec $CONTAINER_ID go tool pprof -raw -output=/tmp/allocs.prof -alloc_objects -pid=$POCKETBASE_PID
        
        # Block profile  
        echo "5/5 Block profiling..."
        docker exec $CONTAINER_ID go tool pprof -raw -output=/tmp/block.prof -block -pid=$POCKETBASE_PID
        
        # Wait for CPU profiling to finish
        wait
        
        # Copy all profiles
        docker cp $CONTAINER_ID:/tmp/cpu.prof ./cpu.prof
        docker cp $CONTAINER_ID:/tmp/heap.prof ./heap.prof
        docker cp $CONTAINER_ID:/tmp/goroutine.prof ./goroutine.prof
        docker cp $CONTAINER_ID:/tmp/allocs.prof ./allocs.prof
        docker cp $CONTAINER_ID:/tmp/block.prof ./block.prof
        
        echo "All profiles saved!"
        echo "Analyze with:"
        echo "  go tool pprof cpu.prof"
        echo "  go tool pprof heap.prof"
        echo "  go tool pprof goroutine.prof"
        echo "  go tool pprof allocs.prof"
        echo "  go tool pprof block.prof"
        ;;
        
    *)
        echo "Invalid option"
        exit 1
        ;;
esac

echo ""
echo "Profiling session saved in: $(pwd)"
