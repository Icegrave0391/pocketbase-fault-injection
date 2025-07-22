#!/bin/bash
# 启用 PocketBase 的 pprof 端点

echo "启用 PocketBase pprof 监控..."

# 方法1: 通过环境变量启用 pprof
export GODEBUG=memprofilerate=1

# 方法2: 如果 PocketBase 支持，可以通过启动参数
# ./pocketbase serve --dev --debug

# 访问 pprof 端点的示例：
echo "pprof 端点将在以下地址可用："
echo "- 内存分析: http://localhost:8090/debug/pprof/heap"
echo "- CPU 分析: http://localhost:8090/debug/pprof/profile"
echo "- 协程分析: http://localhost:8090/debug/pprof/goroutine"
echo "- 所有分析: http://localhost:8090/debug/pprof/"

# 使用 go tool pprof 分析内存
echo ""
echo "使用命令分析内存："
echo "go tool pprof http://localhost:8090/debug/pprof/heap"
echo "go tool pprof http://localhost:8090/debug/pprof/profile?seconds=30"
