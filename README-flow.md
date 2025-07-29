# PocketBase Development Environment Guide

## New Development Workflow

### Directory Structure:
```
pocketbase-fault-injection/
├── Dockerfile
├── build-docker.sh        # Build the development environment (docker)
├── run-dev.sh             # Start the development container
└── docker-shared/         # Shared directory (mounted into container)
    ├── pocketbase/        # PocketBase source code
    ├── pocketbase-build.sh   # Build script
    └── pocketbase-serve.sh   # Service startup script
```

### Usage steps：

#### 1. Build the development environment

```bash
./build-docker.sh
```

#### 2. Start the development container
```bash
./run-dev.sh
```
Inside the Docker container, an interactive `bash shell` will prompt. You can execute whatever commands you want.

#### 3. Build PocketBase inside the container

```bash
./pocketbase-build.sh
```
Whenever we modify the source code of Pocketbase (e.g., injecting some faults), we just need to rebuild it inside the container.

#### 4. Start the pocketbase service inside the container

```bash
./pocketbase-serve.sh
```

#### 5. Access the service

The base server will be at `http://localhost:8090`. 
At the client side (outside the Docker container), we can use any APIs and HTTP requests (acceptable by Pocketbase) to interact with it.

### Common Operations:

- **修改源码后重新构建**：在容器内运行 `./pocketbase-build.sh`
- **重启服务**：Ctrl+C停止服务，然后重新运行 `./pocketbase-serve.sh`
- **退出容器**：Ctrl+D 或输入 `exit`
- **重启容器**：运行 `./quick-rebuild.sh`

### Key directory mappings:
- Docker container's `/workspace` → `docker-shared/` on host
-  PocketBase source code: Docker's `/workspace/pocketbase` → `docker-shared/pocketbase` on host
