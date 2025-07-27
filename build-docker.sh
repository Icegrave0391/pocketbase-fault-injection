#!/usr/bin/env bash
set -e

# PocketBase 开发环境构建脚本

echo "===> Preparing docker-shared directory..."
mkdir -p docker-shared

# 如果pocketbase目录存在且不在docker-shared中，移动它
if [ -d "pocketbase" ] && [ ! -d "docker-shared/pocketbase" ]; then
    echo "Moving pocketbase to docker-shared/"
    mv pocketbase docker-shared/
fi

echo "===> Building PocketBase development environment..."
docker build -t pocketbase-dev .
echo "=== Development environment built successfully!"
echo ""
echo "To start development:"
echo "  ./run-docker.sh"
echo ""
echo "Inside the container, you can:"
echo "  cd pocketbase"
echo "  ./pocketbase-build.sh    # Build the project"
echo "  ./pocketbase-serve.sh    # Start the server"
