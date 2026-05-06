# AnchorHub-wails

> Wails v2 桌面应用模板 + AI Skill 入口。Go + Vue 3 + Naive UI，提炼自多个生产项目，开箱即用。

**AnchorHub：技术资产蒸馏器。存储核心架构规范、UI 审美标准与 AI Agent 协作协议。**

## 这是什么？

AnchorHub-wails 是一套**可复用的 Wails 桌面应用脚手架**，把以下内容沉淀下来：

- ✅ **统一技术栈**：Wails v2 + Go 1.25+ + Vue 3 + TypeScript 5 + Vite + Naive UI（**始终拉最新稳定版**，详见 `docs/02-tech-stack.md`）
- ✅ **统一设计规范**：Apple 风格，精确到 px 的布局、色板、圆角、阴影
- ✅ **统一工程实践**：目录结构、前后端通信、事件驱动、可选模块（暗黑/日志/配置）
- ✅ **统一构建脚本**：图标自动生成 + macOS Universal + Windows amd64 一键打包
- ✅ **AI Skill 入口**：统一的 Claude / Codex CLI / Codex App / Gemini CLI 接入说明，自动替换占位符、裁剪可选模块

## 快速使用（30 秒新建项目）

### 方式 1：用 AI 入口（推荐）

```bash
# Claude Code / Claude CLI 兼容入口
ln -s /Users/curie/GoProject/AnchorHub-wails/skill ~/.claude/skills/anchorhub-wails
```

Codex CLI / Codex App / Gemini CLI 的入口见 [skill/INSTALL.md](./skill/INSTALL.md)。安装后可以直接对对应 Agent 说：

> "用 AnchorHub 模板新建一个 Wails 桌面工具，名字叫 PdfMerger"

Agent 会按公共协议读取模板、询问必要参数，并自动初始化骨架；如果当前平台不能执行命令，至少会列出可手动执行的命令。

### 方式 2：用一键创建脚本

```bash
# 1. 一条命令复制 template 并初始化
bash /Users/curie/GoProject/AnchorHub-wails/scripts/create-project.sh ~/GoProject/MyTool

# 2. 进入项目目录
cd ~/GoProject/MyTool

# 3. 按提示安装依赖、生成图标、启动开发
go get -u github.com/wailsapp/wails/v2@latest && go mod tidy
cd frontend && npm install && cd ..
./set-icon.sh    # 需要先准备 icon.png
wails dev
```

非交互式示例：

```bash
TARGET_DIR=~/GoProject/MyTool \
APP_NAME=MyTool \
APP_TITLE="我的工具" \
BUNDLE_ID=com.curie.mytool \
bash /Users/curie/GoProject/AnchorHub-wails/scripts/create-project.sh --non-interactive --upgrade
```

## 目录结构

```
AnchorHub-wails/
├── README.md                    # 本文件（使用入口）
│
├── docs/                        # 核心文档
│   ├── 01-design-system.md      # 设计规范（精确到 px）
│   ├── 02-tech-stack.md         # 技术栈选型与版本锁定
│   ├── 03-usage-guide.md        # 详细使用指南
│   └── 04-agent-usage-protocol.md # 平台无关 AI 协作协议
│
├── adapters/                    # 多 Agent 平台入口
│   ├── common/                  # 通用 Prompt
│   ├── claude/                  # Claude CLI / Claude Code
│   ├── codex/                   # Codex CLI / Codex App
│   └── gemini/                  # Gemini CLI
│
├── template/                    # 模板骨架（复制到新项目）
│   ├── main.go                  # Wails 入口
│   ├── go.mod / wails.json
│   ├── backend/                 # Go 后端
│   │   ├── app.go               # API 入口（含通用方法）
│   │   ├── events/              # 事件定义
│   │   ├── logger/              # （可选）日志模块
│   │   └── config/              # （可选）配置模块
│   ├── frontend/                # Vue 3 前端
│   │   └── src/
│   │       ├── App.vue          # 整体布局壳
│   │       ├── router/
│   │       ├── stores/
│   │       ├── views/
│   │       ├── components/
│   │       ├── services/        # Wails API 封装
│   │       ├── utils/
│   │       └── types/
│   ├── build/                   # 图标资源
│   ├── build-all.sh             # 双平台打包
│   ├── set-icon.sh              # 图标生成
│   └── README.md
│
├── scripts/
│   ├── create-project.sh        # 复制模板并调用初始化脚本
│   └── init-project.sh          # 占位符替换脚本
│
└── skill/                       # AI Skill 入口
    ├── SKILL.md                 # Skill 定义
    └── INSTALL.md               # 安装说明
```

## 设计规范要点

详见 [docs/01-design-system.md](./docs/01-design-system.md)。最关键的几点：

| 元素 | 规范 |
|---|---|
| 侧边栏宽度 | `200px`（固定） |
| 内容区背景 | `#f5f7fa` |
| 卡片圆角 | `20px`（大圆角风格） |
| 按钮圆角 | `8px`，高度 `42px` |
| 主色 | Apple Blue `#007AFF`（如启用主题覆盖） |
| 字体 | `-apple-system` 优先 |
| 滚动条 | `:native-scrollbar="false"`（Naive 自定义） |

## 可选模块清单

模板默认提供**最小骨架**，以下模块按需启用：

| 模块 | 启用时机 | 启用方式 |
|---|---|---|
| 暗黑主题切换 | 工具型应用，长时间使用 | `App.vue` 取消注释 + 启用 `SetDarkMode` |
| 本地日志持久化 | 需要审计、回查操作 | `Startup` 中 `logger.NewLogger()` |
| 配置持久化 | 用户需保存偏好/凭证 | `Startup` 中 `config.NewManager()` |
| 拖拽上传 | 文件处理类工具 | `main.go` 已默认启用 |
| 进度事件 | 长耗时任务（>2秒） | 用 `events` + `EventsEmit/On` |

## 占位符清单

模板中的占位符（首次初始化时由脚本替换）：

| 占位符 | 含义 | 示例 |
|---|---|---|
| `{{APP_NAME}}` | 应用名（PascalCase） | `MyTool` |
| `{{APP_NAME_LOWER}}` | 应用名小写 | `mytool` |
| `{{APP_TITLE}}` | 窗口标题 | `我的工具` |
| `{{APP_DESCRIPTION}}` | 应用简介 | `处理 XX 的桌面工具` |
| `{{BUNDLE_ID}}` | macOS bundleId | `com.curie.mytool` |
| `{{COMPANY_NAME}}` | 公司/作者 | `Curie` |
| `{{AUTHOR_EMAIL}}` | 作者邮箱 | `you@example.com` |
| `{{COPYRIGHT_YEAR}}` | 版权年份 | `2026` |
| `{{WINDOW_WIDTH}}` | 窗口宽度 | `1180` |
| `{{WINDOW_HEIGHT}}` | 窗口高度 | `900` |

## 模板提炼来源

本模板提炼自以下生产项目：

- **TidyBilling**：单页应用 + 进度事件 + 拖拽上传
- **Invoice2OSS**：多页应用 + 暗黑主题 + 日志 + 配置持久化

## 维护

### 更新模板

模板有改进时直接修改 `template/` 下的文件，已经基于此模板建立的项目可参考 `CHANGELOG.md` 手动同步关键改动。

### 版本策略

**始终使用最新稳定版**，避免"模板写于半年前，新项目就已经过时"的问题：

- 模板里的版本号只是"最低支持基线"
- 前端 `package.json` 全部写 `"latest"`，首次 `npm install` 自动拉到最新
- Go 端建议初始化后跑：`go get -u github.com/wailsapp/wails/v2@latest && go mod tidy`
- 已有项目升级用：`npm run upgrade-latest`（前端）+ `go get -u ./...`（后端）

详见 [docs/02-tech-stack.md](./docs/02-tech-stack.md) 的"版本策略"章节。

## License

MIT © Curie

---

**相关项目**：
- AnchorHub-Web（待建）
- AnchorHub-MiniProgram（待建）
