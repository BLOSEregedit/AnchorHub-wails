#!/bin/bash

# {{APP_NAME}} 双平台构建脚本
# 输出：application/{{APP_NAME}}.app（macOS Universal）+ application/{{APP_NAME}}.exe（Windows amd64）

set -e

echo "======================================"
echo "  {{APP_NAME}} 双平台构建脚本"
echo "======================================"
echo ""

echo "清理旧构建产物..."
rm -rf application
mkdir -p application
echo "输出目录已准备"
echo ""

echo "步骤 1/3: 重新生成应用图标..."
./set-icon.sh
echo "图标生成完成"
echo ""

echo "步骤 2/3: 构建 macOS 版本 (Universal Binary)..."
wails build -platform darwin/universal -clean
echo "macOS 构建完成"

if [ -d "build/bin/{{APP_NAME}}.app" ]; then
    echo "移动 macOS 构建产物..."
    mv build/bin/{{APP_NAME}}.app application/
fi
echo ""

echo "步骤 3/3: 构建 Windows 版本 (amd64)..."
wails build -platform windows/amd64 -clean
echo "Windows 构建完成"

if [ -f "build/bin/{{APP_NAME}}.exe" ]; then
    echo "移动 Windows 构建产物..."
    mv build/bin/{{APP_NAME}}.exe application/
fi
echo ""

echo "======================================"
echo "  所有构建完成"
echo "======================================"
echo ""
echo "构建产物目录: application/"
echo ""

if [ -d "application" ]; then
    echo "文件列表:"
    ls -lh application/ | tail -n +2 | awk '{printf "  - %s  (%s)\n", $9, $5}'
fi

echo ""
echo "说明："
echo "  - macOS 版本: application/{{APP_NAME}}.app"
echo "  - Windows 版本: application/{{APP_NAME}}.exe"
echo ""
