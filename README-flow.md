# PocketBase 开发环境使用指南

## 新的开发流程

### 目录结构：
```
pocketbase-fault-injection/
├── Dockerfile
├── build-docker.sh         # 构建开发环境
├── run-dev.sh             # 启动开发容器
├── quick-rebuild.sh       # 快速重启容器
└── docker-shared/         # 共享目录（挂载到容器）
    ├── pocketbase/        # PocketBase源码
    ├── pocketbase-build.sh   # 构建脚本
    └── pocketbase-serve.sh   # 服务启动脚本
```

### 使用步骤：

#### 1. 构建开发环境
```bash
./build-docker.sh
```

#### 2. 启动开发容器
```bash
./run-dev.sh
```
这会启动一个交互式bash shell，你可以在其中执行各种命令。

#### 3. 在容器内构建PocketBase
```bash
# 容器内执行：
cd pocketbase
./pocketbase-build.sh
```

#### 4. 在容器内启动服务
```bash
# 容器内执行：
./pocketbase-serve.sh
```

#### 5. 访问服务
在浏览器中访问: http://localhost:8090

### 优势：

1. **细粒度控制**：你可以决定何时构建、何时启动
2. **灵活性**：可以在容器内执行任何命令，调试更方便
3. **实时同步**：docker-shared目录实时同步，修改源码立即生效
4. **分离关注点**：构建和运行分开，更清晰

### 常用操作：

- **修改源码后重新构建**：在容器内运行 `./pocketbase-build.sh`
- **重启服务**：Ctrl+C停止服务，然后重新运行 `./pocketbase-serve.sh`
- **退出容器**：Ctrl+D 或输入 `exit`
- **重启容器**：运行 `./quick-rebuild.sh`

### 容器内的工作目录：
- `/workspace` - 对应host的 `docker-shared/`
- `/workspace/pocketbase` - PocketBase源码目录
