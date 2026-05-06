#!/bin/bash

# AnchorHub-wails 模板初始化脚本
#
# 用法：
#   1. 把 template/ 目录复制到目标路径
#   2. 进入目标路径，执行：
#      bash /path/to/AnchorHub-wails/scripts/init-project.sh
#   3. 按提示输入参数即可完成初始化
#
# 可选参数：
#   --non-interactive  从环境变量读取参数，CI 友好
#   --upgrade          替换占位符后，自动 go get -u + npm install 拉到最新稳定版
#
# 也可以非交互式调用（CI 友好）：
#   APP_NAME=MyTool APP_TITLE="我的工具" BUNDLE_ID=com.curie.mytool \
#     bash init-project.sh --non-interactive --upgrade

set -e

echo "======================================"
echo "  AnchorHub-wails 项目初始化"
echo "======================================"
echo ""

# ----------------- 参数读取 -----------------

NON_INTERACTIVE=false
DO_UPGRADE=false
for arg in "$@"; do
    case "$arg" in
        --non-interactive) NON_INTERACTIVE=true ;;
        --upgrade)         DO_UPGRADE=true ;;
    esac
done

prompt() {
    local var_name=$1
    local question=$2
    local default=$3

    if [ "$NON_INTERACTIVE" = "true" ]; then
        eval "value=\${$var_name:-$default}"
        echo "$var_name=$value"
        eval "$var_name=\"\$value\""
        return
    fi

    if [ -n "$default" ]; then
        read -p "$question [$default]: " input
        eval "$var_name=\"\${input:-$default}\""
    else
        read -p "$question: " input
        eval "$var_name=\"$input\""
    fi
}

prompt APP_NAME         "应用名（PascalCase，如 MyTool）"             ""
prompt APP_TITLE        "应用标题（窗口标题，可含中文）"               "$APP_NAME"
prompt APP_DESCRIPTION  "应用简介"                                    "A Wails desktop tool"
prompt COMPANY_NAME     "公司/作者名"                                "Curie"
prompt AUTHOR_EMAIL     "作者邮箱（可空）"                            ""
prompt BUNDLE_ID        "macOS bundleId（如 com.curie.mytool）"       "com.curie.$(echo $APP_NAME | tr '[:upper:]' '[:lower:]')"
prompt WINDOW_WIDTH     "窗口宽度（像素）"                            "1180"
prompt WINDOW_HEIGHT    "窗口高度（像素）"                            "900"

CURRENT_YEAR=$(date +%Y)
prompt COPYRIGHT_YEAR   "版权年份"                                    "$CURRENT_YEAR"

APP_NAME_LOWER=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')

if [ -z "$APP_NAME" ]; then
    echo "错误：APP_NAME 不能为空"
    exit 1
fi

# ----------------- 确认 -----------------

echo ""
echo "----- 配置预览 -----"
echo "APP_NAME        : $APP_NAME"
echo "APP_NAME_LOWER  : $APP_NAME_LOWER"
echo "APP_TITLE       : $APP_TITLE"
echo "APP_DESCRIPTION : $APP_DESCRIPTION"
echo "COMPANY_NAME    : $COMPANY_NAME"
echo "AUTHOR_EMAIL    : $AUTHOR_EMAIL"
echo "BUNDLE_ID       : $BUNDLE_ID"
echo "WINDOW_WIDTH    : $WINDOW_WIDTH"
echo "WINDOW_HEIGHT   : $WINDOW_HEIGHT"
echo "COPYRIGHT_YEAR  : $COPYRIGHT_YEAR"
echo "--------------------"
echo ""

if [ "$NON_INTERACTIVE" != "true" ]; then
    read -p "确认替换？(y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "已取消"
        exit 0
    fi
fi

# ----------------- 替换 -----------------

echo "开始替换占位符..."

# macOS sed 需要 ''
SED_INPLACE="sed -i ''"
if [[ "$(uname)" != "Darwin" ]]; then
    SED_INPLACE="sed -i"
fi

replace_in_files() {
    local placeholder=$1
    local value=$2
    # 转义 sed 特殊字符
    local escaped=$(echo "$value" | sed -e 's/[\/&|]/\\&/g')
    find . -type f \( \
        -name "*.go" -o -name "*.json" -o -name "*.ts" -o -name "*.tsx" \
        -o -name "*.vue" -o -name "*.md" -o -name "*.sh" -o -name "*.html" \
        -o -name "*.mod" -o -name ".gitignore" \
    \) \
    -not -path "./node_modules/*" \
    -not -path "./.git/*" \
    -not -path "./build/bin/*" \
    -not -path "./application/*" \
    -not -path "./frontend/dist/*" \
    -not -path "./frontend/wailsjs/*" \
    -exec $SED_INPLACE "s|{{$placeholder}}|$escaped|g" {} \;
}

replace_in_files "APP_NAME"        "$APP_NAME"
replace_in_files "APP_NAME_LOWER"  "$APP_NAME_LOWER"
replace_in_files "APP_TITLE"       "$APP_TITLE"
replace_in_files "APP_DESCRIPTION" "$APP_DESCRIPTION"
replace_in_files "COMPANY_NAME"    "$COMPANY_NAME"
replace_in_files "AUTHOR_EMAIL"    "$AUTHOR_EMAIL"
replace_in_files "BUNDLE_ID"       "$BUNDLE_ID"
replace_in_files "WINDOW_WIDTH"    "$WINDOW_WIDTH"
replace_in_files "WINDOW_HEIGHT"   "$WINDOW_HEIGHT"
replace_in_files "COPYRIGHT_YEAR"  "$COPYRIGHT_YEAR"

# 给脚本可执行权限
chmod +x set-icon.sh build-all.sh 2>/dev/null || true

echo "替换完成"
echo ""

# ----------------- 可选：拉取最新稳定版依赖 -----------------

if [ "$DO_UPGRADE" = "true" ]; then
    echo "======================================"
    echo "  拉取最新稳定版依赖（--upgrade 已启用）"
    echo "======================================"
    echo ""

    if command -v go >/dev/null 2>&1; then
        echo "→ go get -u github.com/wailsapp/wails/v2@latest"
        go get -u github.com/wailsapp/wails/v2@latest || true
        echo "→ go mod tidy"
        go mod tidy || true
    else
        echo "⚠️  未检测到 go，跳过 Go 依赖升级"
    fi

    if command -v npm >/dev/null 2>&1; then
        echo "→ cd frontend && npm install（package.json 已写 latest）"
        ( cd frontend && npm install ) || true
    else
        echo "⚠️  未检测到 npm，跳过前端依赖安装"
    fi

    echo ""
    echo "依赖已拉取最新稳定版"
    echo ""
fi

echo "======================================"
echo "  下一步操作"
echo "======================================"
echo ""

if [ "$DO_UPGRADE" = "true" ]; then
    echo "依赖已自动安装，可直接进入下一步："
    echo ""
    echo "1. 准备应用图标（1024x1024 PNG，命名为 icon.png 放项目根）"
    echo ""
    echo "2. 生成图标："
    echo "   ./set-icon.sh"
    echo ""
    echo "3. 启动开发模式："
    echo "   wails dev"
    echo ""
    echo "4. 双平台打包："
    echo "   ./build-all.sh"
else
    echo "1. 安装依赖（推荐顺手升级到最新稳定版）："
    echo "   go get -u github.com/wailsapp/wails/v2@latest && go mod tidy"
    echo "   cd frontend && npm install && cd .."
    echo ""
    echo "   （或重新跑本脚本时加 --upgrade 一键完成）"
    echo ""
    echo "2. 准备应用图标（1024x1024 PNG，命名为 icon.png 放项目根）"
    echo ""
    echo "3. 生成图标："
    echo "   ./set-icon.sh"
    echo ""
    echo "4. 启动开发模式："
    echo "   wails dev"
    echo ""
    echo "5. 双平台打包："
    echo "   ./build-all.sh"
fi
echo ""
