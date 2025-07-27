#!/bin/bash

# PocketBase 开发容器启动脚本

SHARED_PATH="./docker-shared"

if [ ! -d "$SHARED_PATH" ]; then
    echo "Error: docker-shared directory not found!"
    echo "Please run ./build-docker.sh first"
    exit 1
fi

echo "Starting PocketBase development container..."
echo "Shared directory: $(realpath $SHARED_PATH)"
echo "Container access: http://localhost:8090"
echo ""
echo "Commands inside container:"
echo "  cd pocketbase"
echo "  ./pocketbase-build.sh    # Build the project"
echo "  ./pocketbase-serve.sh    # Start the server"
echo ""
echo "Press Ctrl+D or type 'exit' to leave container"
echo ""

docker run -it --rm \
    -p 8090:8090 \
    -v "$(realpath $SHARED_PATH):/workspace" \
    pocketbase-dev
