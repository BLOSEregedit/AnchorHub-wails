---
name: anchorhub-wails
description: 基于 AnchorHub-wails 模板初始化新的 Wails v2 桌面应用（Go + Vue 3 + Naive UI），自动完成占位符替换、依赖建议、图标准备指引。当用户说"新建 wails 项目""创建桌面工具""用 anchorhub 模板"或类似意图时使用。
---

# AnchorHub-wails 项目初始化 Skill

## 何时使用此 Skill

当用户表达以下任一意图时启用：

- "新建一个 Wails 项目"
- "用 AnchorHub 模板创建桌面工具"
- "帮我初始化一个 XXX 桌面应用"
- "复用我那套 Wails 模板"

## 执行流程

### 第 1 步：信息收集（用 AskUserQuestion 工具）

向用户询问以下参数（一次性问全，不要分多次）：

1. **应用名（APP_NAME）**：PascalCase，无空格，例如 `MyTool`
2. **应用标题（APP_TITLE）**：窗口标题，可含中文，例如"我的工具"
3. **应用简介（APP_DESCRIPTION）**：一句话描述
4. **目标目录**：例如 `/Users/curie/GoProject/MyTool`
5. **可选模块**（多选）：
   - 暗黑主题切换
   - 本地日志持久化
   - 配置持久化
   - 拖拽文件上传（默认开启）

可推断的参数（无需询问）：

- `APP_NAME_LOWER`：APP_NAME 转小写
- `BUNDLE_ID`：默认 `com.curie.{APP_NAME_LOWER}`
- `COMPANY_NAME`：默认 `Curie`
- `COPYRIGHT_YEAR`：当前年份
- `WINDOW_WIDTH/HEIGHT`：默认 `1180 x 900`

### 第 2 步：复制模板

```bash
# 模板路径（固定）
TEMPLATE_DIR=/Users/curie/GoProject/AnchorHub-wails/template

# 复制到目标目录
mkdir -p {目标目录}
cp -R $TEMPLATE_DIR/. {目标目录}/
```

### 第 3 步：执行初始化脚本

> 默认**不**自动升级依赖。如果用户明确要"开箱即用、马上启动"，就加 `--upgrade` 让脚本自动跑 `go get -u` + `npm install`，把所有依赖拉到最新稳定版。

```bash
cd {目标目录}
APP_NAME={APP_NAME} \
APP_TITLE="{APP_TITLE}" \
APP_DESCRIPTION="{APP_DESCRIPTION}" \
COMPANY_NAME="{COMPANY_NAME}" \
AUTHOR_EMAIL="{AUTHOR_EMAIL}" \
BUNDLE_ID="{BUNDLE_ID}" \
WINDOW_WIDTH={WINDOW_WIDTH} \
WINDOW_HEIGHT={WINDOW_HEIGHT} \
COPYRIGHT_YEAR={COPYRIGHT_YEAR} \
bash /Users/curie/GoProject/AnchorHub-wails/scripts/init-project.sh --non-interactive
# 如用户要求自动安装依赖，追加 --upgrade
```

### 第 4 步：根据可选模块裁剪

按用户选择处理：

#### 不启用"暗黑主题切换"
- 删除 `backend/app.go` 中的 `SetDarkMode` 方法
- `App.vue` 中保持注释状态（默认）

#### 不启用"本地日志"
- 删除 `backend/logger/` 整个目录
- 从 `go.mod` 中移除 `github.com/google/uuid`（如果只有 logger 用到）

#### 不启用"配置持久化"
- 删除 `backend/config/` 整个目录

#### 不启用"拖拽上传"
- 修改 `main.go`，删除 `DragAndDrop` 配置块

### 第 5 步：输出"下一步指引"

向用户输出明确的后续步骤（**不要替用户执行**，只提示）：

```
模板初始化完成！下一步请手动执行：

1. 进入项目目录：
   cd {目标目录}

2. 安装依赖（推荐顺手升级到最新稳定版）：
   go get -u github.com/wailsapp/wails/v2@latest && go mod tidy
   cd frontend && npm install && cd ..

   说明：
   - go.mod 里的版本号只是基线，go get -u 会拉到最新稳定版
   - frontend/package.json 已写 "latest"，npm install 自动拉最新

3. 准备应用图标：
   将 1024x1024 PNG 命名为 icon.png 放项目根，然后：
   ./set-icon.sh

4. 启动开发模式：
   wails dev

5. 双平台打包：
   ./build-all.sh
```

## 设计规范（必须遵守）

引导用户在后续业务开发中遵守 `docs/01-design-system.md` 的规范：

- 侧边栏宽度 `200px`
- 内容区背景 `#f5f7fa`
- 卡片圆角 `20px`
- 按钮圆角 `8px`，高度 `42px`
- 卡片间距 `n-space :size="16"`
- 字体优先 `-apple-system`

## 业务代码生成规范

如果用户在初始化后请求"添加 XX 功能"，按以下规范生成：

### 添加新菜单项 / 视图

1. `frontend/src/views/{ViewName}.vue` 创建视图
2. `frontend/src/router/index.ts` 添加路由
3. `frontend/src/App.vue` 的 `menuOptions` 添加菜单项
4. 如有独立状态：`frontend/src/stores/{name}Store.ts`

### 添加后端业务

1. `backend/{domain}/` 创建领域包
2. 在 `backend/app.go` 的 `App` 结构体持有 manager 指针
3. 在 `Startup` 中初始化
4. 在 `app.go` 暴露 API 方法（首字母大写）
5. 长耗时任务用 `events` 推进度，不要同步阻塞

### 前后端通信

- 前端调用：通过 `services/wails.ts` 统一封装，**禁止**组件直接 import wailsjs
- 后端事件命名：`<domain>:<action>:<state>`，如 `convert:process:progress`
- 错误处理：前端用 `normalizeError()` 标准化

## 关键约束

1. **不要修改用户已有代码**：如果目标目录非空，先警告并征求同意
2. **不要默认自动安装依赖**：默认让用户手动跑 `go mod tidy` / `npm install`，避免锁文件冲突；**仅当用户明确要求"自动安装"或"开箱即用"时**，才在 init 脚本上加 `--upgrade` 拉取最新稳定版
3. **不要自动生成图标**：让用户准备 `icon.png` 后手动执行 `set-icon.sh`
4. **不要自动 git init**：让用户决定何时初始化 git
5. **依赖版本始终最新稳定版**：模板 `package.json` 已用 `"latest"`，Go 端用 `go get -u ...@latest`

## 参考文档

- 设计规范：`/Users/curie/GoProject/AnchorHub-wails/docs/01-design-system.md`
- 技术栈：`/Users/curie/GoProject/AnchorHub-wails/docs/02-tech-stack.md`
- 使用指南：`/Users/curie/GoProject/AnchorHub-wails/docs/03-usage-guide.md`
- 模板源：`/Users/curie/GoProject/AnchorHub-wails/template/`
- 参考实现：
  - 简单（单页 + 进度事件）：`/Users/curie/GoProject/TidyBilling`
  - 完整（多页 + 暗黑 + 日志 + 配置）：`/Users/curie/GoProject/Invoice2OSS`
