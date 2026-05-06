#!/bin/bash

# {{APP_NAME}} 图标生成脚本
#
# 使用方法：
# 1. 准备 1024x1024 PNG 图片，命名为 icon.png 放在项目根目录
# 2. 运行：./set-icon.sh
#
# 依赖：
# - macOS：sips（系统自带）+ iconutil（系统自带）
# - Windows .ico：ImageMagick（brew install imagemagick）

set -e

echo "=== {{APP_NAME}} 图标生成 ==="
echo ""

if [ ! -f "icon.png" ]; then
    echo "错误：找不到 icon.png 文件"
    echo "请将 1024x1024 PNG 图片命名为 icon.png 放在项目根目录"
    exit 1
fi

if ! command -v sips >/dev/null 2>&1; then
    echo "错误：当前系统缺少 sips 命令（需要 macOS 环境）"
    exit 1
fi

if ! command -v iconutil >/dev/null 2>&1; then
    echo "错误：当前系统缺少 iconutil 命令（需要 macOS 环境）"
    exit 1
fi

SIZE=$(sips -g pixelWidth -g pixelHeight icon.png | grep -E "pixelWidth|pixelHeight" | awk '{print $2}')
WIDTH=$(echo $SIZE | cut -d' ' -f1)
HEIGHT=$(echo $SIZE | cut -d' ' -f2)

echo "检测到图片尺寸：${WIDTH}x${HEIGHT}"

if [ "$WIDTH" != "$HEIGHT" ]; then
    echo "警告：图片不是正方形，可能导致图标变形"
    echo "建议使用正方形图片，例如 1024x1024"
    read -p "是否继续？(y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo ""
echo "开始生成图标..."

echo "  - 更新开发模式图标..."
mkdir -p build
cp icon.png build/appicon.png

echo "  - 生成 macOS 图标 (.icns)..."
mkdir -p icon.iconset

sips -z 16 16     icon.png --out icon.iconset/icon_16x16.png > /dev/null 2>&1
sips -z 32 32     icon.png --out icon.iconset/icon_16x16@2x.png > /dev/null 2>&1
sips -z 32 32     icon.png --out icon.iconset/icon_32x32.png > /dev/null 2>&1
sips -z 64 64     icon.png --out icon.iconset/icon_32x32@2x.png > /dev/null 2>&1
sips -z 128 128   icon.png --out icon.iconset/icon_128x128.png > /dev/null 2>&1
sips -z 256 256   icon.png --out icon.iconset/icon_128x128@2x.png > /dev/null 2>&1
sips -z 256 256   icon.png --out icon.iconset/icon_256x256.png > /dev/null 2>&1
sips -z 512 512   icon.png --out icon.iconset/icon_256x256@2x.png > /dev/null 2>&1
sips -z 512 512   icon.png --out icon.iconset/icon_512x512.png > /dev/null 2>&1
sips -z 1024 1024 icon.png --out icon.iconset/icon_512x512@2x.png > /dev/null 2>&1

iconutil -c icns icon.iconset -o appicon.icns

mkdir -p build/darwin
mv appicon.icns build/darwin/

rm -rf icon.iconset

mkdir -p build/windows

if command -v magick >/dev/null 2>&1; then
    echo "  - 生成 Windows 图标 (.ico)..."
    magick icon.png -define icon:auto-resize=256,128,64,48,32,16 build/windows/icon.ico
else
    echo "  - 未检测到 ImageMagick，跳过 Windows icon.ico 生成"
    echo "    安装命令：brew install imagemagick"
fi

echo ""
echo "图标生成完成"
echo "  - build/appicon.png        （wails dev 使用）"
echo "  - build/darwin/appicon.icns（macOS 构建使用）"
echo "  - build/windows/icon.ico   （Windows 构建使用，需 ImageMagick）"
