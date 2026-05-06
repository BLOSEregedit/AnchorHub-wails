#!/bin/bash

# AnchorHub-wails 一键创建项目脚本
#
# 用法：
#   bash scripts/create-project.sh /path/to/MyTool
#   bash scripts/create-project.sh /path/to/MyTool --upgrade
#
# 非交互式：
#   TARGET_DIR=/path/to/MyTool APP_NAME=MyTool APP_TITLE="我的工具" \
#     bash scripts/create-project.sh --non-interactive --upgrade

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="$REPO_ROOT/template"
INIT_SCRIPT="$SCRIPT_DIR/init-project.sh"

NON_INTERACTIVE=false
DO_UPGRADE=false
TARGET_DIR_INPUT="${TARGET_DIR:-}"

usage() {
    cat <<EOF
用法：
  bash scripts/create-project.sh <目标目录> [--non-interactive] [--upgrade]

参数：
  --non-interactive  不询问，目标目录优先取位置参数，其次取环境变量 TARGET_DIR
  --upgrade          初始化后自动拉取最新稳定版依赖
  --help             查看帮助

环境变量：
  TARGET_DIR         非交互式时的目标目录
  APP_NAME           应用名（必填）
  APP_TITLE          应用标题
  APP_DESCRIPTION    应用简介
  COMPANY_NAME       公司/作者名
  AUTHOR_EMAIL       作者邮箱
  BUNDLE_ID          macOS bundleId
  WINDOW_WIDTH       窗口宽度
  WINDOW_HEIGHT      窗口高度
  COPYRIGHT_YEAR     版权年份
EOF
}

for arg in "$@"; do
    case "$arg" in
        --non-interactive) NON_INTERACTIVE=true ;;
        --upgrade)         DO_UPGRADE=true ;;
        --help|-h)
            usage
            exit 0
            ;;
        --*)
            echo "错误：未知参数 $arg"
            usage
            exit 1
            ;;
        *)
            if [ -n "$TARGET_DIR_INPUT" ] && [ "$TARGET_DIR_INPUT" != "$arg" ]; then
                echo "错误：仅支持一个目标目录参数"
                usage
                exit 1
            fi
            TARGET_DIR_INPUT="$arg"
            ;;
    esac
done

if [ "$NON_INTERACTIVE" = "true" ] && [ -z "$TARGET_DIR_INPUT" ]; then
    echo "错误：--non-interactive 模式下必须提供目标目录参数，或设置 TARGET_DIR 环境变量"
    exit 1
fi

if [ -z "$TARGET_DIR_INPUT" ]; then
    read -r -p "目标目录（绝对或相对路径）: " TARGET_DIR_INPUT
fi

if [ -z "$TARGET_DIR_INPUT" ]; then
    echo "错误：目标目录不能为空"
    exit 1
fi

case "$TARGET_DIR_INPUT" in
    "~")
        TARGET_DIR="$HOME"
        ;;
    "~/"*)
        TARGET_DIR="$HOME/${TARGET_DIR_INPUT#~/}"
        ;;
    /*)
        TARGET_DIR="$TARGET_DIR_INPUT"
        ;;
    *)
        TARGET_DIR="$PWD/$TARGET_DIR_INPUT"
        ;;
esac

if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "错误：未找到模板目录：$TEMPLATE_DIR"
    exit 1
fi

if [ ! -f "$INIT_SCRIPT" ]; then
    echo "错误：未找到初始化脚本：$INIT_SCRIPT"
    exit 1
fi

if [ -e "$TARGET_DIR" ] && [ ! -d "$TARGET_DIR" ]; then
    echo "错误：目标路径已存在且不是目录：$TARGET_DIR"
    exit 1
fi

if [ -d "$TARGET_DIR" ] && [ -n "$(find "$TARGET_DIR" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]; then
    echo "错误：目标目录非空，默认拒绝覆盖：$TARGET_DIR"
    echo "请改用空目录，或手动清理后重试。"
    exit 1
fi

mkdir -p "$TARGET_DIR"

echo "======================================"
echo "  AnchorHub-wails 一键创建项目"
echo "======================================"
echo ""
echo "模板来源：$TEMPLATE_DIR"
echo "目标目录：$TARGET_DIR"
echo ""

echo "正在复制模板..."
( cd "$TEMPLATE_DIR" && tar cf - . ) | ( cd "$TARGET_DIR" && tar xpf - )
echo "模板复制完成"
echo ""

INIT_ARGS=()
if [ "$NON_INTERACTIVE" = "true" ]; then
    INIT_ARGS+=("--non-interactive")
fi
if [ "$DO_UPGRADE" = "true" ]; then
    INIT_ARGS+=("--upgrade")
fi

echo "正在初始化项目..."
(
    cd "$TARGET_DIR"
    bash "$INIT_SCRIPT" "${INIT_ARGS[@]}"
)

echo ""
echo "项目创建完成：$TARGET_DIR"
