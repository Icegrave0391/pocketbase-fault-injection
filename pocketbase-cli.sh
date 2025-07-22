#!/bin/bash

# PocketBase 命令行管理脚本

CONTAINER_NAME="pocketbase-dev"

echo "===> PocketBase 命令行工具 ==="
echo ""

# 检查容器是否运行
if ! sudo docker ps --filter ancestor=pocketbase-dev --format "{{.Names}}" | grep -q .; then
    echo "错误: PocketBase容器未运行"
    echo "请先运行: ./run-dev.sh"
    exit 1
fi

echo "可用的PocketBase命令行操作："
echo ""
echo "1. 查看PocketBase帮助"
echo "2. 创建管理员用户"
echo "3. 查看数据库信息"
echo "4. 导入数据"
echo "5. 导出数据"
echo "6. 查看日志"
echo "7. 进入容器Shell"
echo "8. 自定义命令"
echo ""

read -p "请选择操作 (1-8): " choice

case $choice in
    1)
        echo "===> 显示PocketBase帮助 ==="
        sudo docker exec -it $(sudo docker ps -q --filter ancestor=$CONTAINER_NAME) bash -c "cd pocketbase && ./pocketbase --help"
        ;;
    2)
        echo "===> 创建管理员用户 ==="
        echo "注意: 这将创建一个超级管理员用户"
        sudo docker exec -it $(sudo docker ps -q --filter ancestor=$CONTAINER_NAME) bash -c "cd pocketbase && ./pocketbase admin create"
        ;;
    3)
        echo "===> 查看数据库信息 ==="
        sudo docker exec -it $(sudo docker ps -q --filter ancestor=$CONTAINER_NAME) bash -c "cd pocketbase && ls -la pb_data/ 2>/dev/null || echo '数据库文件夹不存在，请先启动服务'"
        ;;
    4)
        echo "===> 导入数据 ==="
        echo "请将要导入的文件放在 docker-shared/pocketbase/ 目录下"
        read -p "输入要导入的文件名: " filename
        sudo docker exec -it $(sudo docker ps -q --filter ancestor=$CONTAINER_NAME) bash -c "cd pocketbase && ./pocketbase import $filename"
        ;;
    5)
        echo "===> 导出数据 ==="
        read -p "输入导出文件名 (如: backup.zip): " filename
        sudo docker exec -it $(sudo docker ps -q --filter ancestor=$CONTAINER_NAME) bash -c "cd pocketbase && ./pocketbase export $filename"
        echo "文件已导出到: docker-shared/pocketbase/$filename"
        ;;
    6)
        echo "===> 查看PocketBase日志 ==="
        sudo docker logs $(sudo docker ps -q --filter ancestor=$CONTAINER_NAME)
        ;;
    7)
        echo "===> 进入容器Shell ==="
        echo "在容器内你可以："
        echo "  cd pocketbase"
        echo "  ./pocketbase --help  # 查看所有命令"
        echo "  ./pocketbase serve   # 启动服务"
        echo ""
        sudo docker exec -it $(sudo docker ps -q --filter ancestor=$CONTAINER_NAME) bash
        ;;
    8)
        echo "===> 自定义命令 ==="
        read -p "输入PocketBase命令 (不包含 ./pocketbase): " cmd
        sudo docker exec -it $(sudo docker ps -q --filter ancestor=$CONTAINER_NAME) bash -c "cd pocketbase && ./pocketbase $cmd"
        ;;
    *)
        echo "无效选择"
        ;;
esac
